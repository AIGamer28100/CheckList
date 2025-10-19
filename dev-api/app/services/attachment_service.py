"""
Service for managing task attachments with file storage and metadata
"""
import os
import uuid
import hashlib
import mimetypes
from datetime import datetime
from typing import List, Optional, Dict, Any, Tuple, Union
from pathlib import Path
import aiofiles
import aiofiles.os
import io
import requests
from urllib.parse import urlparse, urljoin
import logging

try:
    from PIL import Image, ImageOps
    PIL_AVAILABLE = True
except ImportError:
    PIL_AVAILABLE = False

try:
    from bs4 import BeautifulSoup
    BS4_AVAILABLE = True
except ImportError:
    BS4_AVAILABLE = False

from app.models.attachment import (
    AttachmentCreate, AttachmentUpdate, AttachmentResponse, AttachmentStats,
    AttachmentSearch, AttachmentType, AttachmentCategory, BulkAttachmentOperation
)
from app.services.firestore_service import FirestoreService

logger = logging.getLogger(__name__)


class AttachmentService:
    """Service for managing task attachments"""
    
    def __init__(self, firestore_service: FirestoreService):
        self.firestore = firestore_service
        self.collection_name = "attachments"
        self.storage_base_path = Path("uploads")  # Default upload directory
        self.max_file_size = 50 * 1024 * 1024  # 50MB default
        self.allowed_mime_types = [
            'image/jpeg', 'image/png', 'image/gif', 'image/webp',
            'application/pdf', 'text/plain', 'text/markdown',
            'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'audio/mpeg', 'audio/wav', 'audio/ogg', 'video/mp4'
        ]
        
        # Ensure upload directory exists
        self.storage_base_path.mkdir(parents=True, exist_ok=True)
    
    async def create_attachment(
        self,
        task_id: str,
        developer_id: str,
        attachment_data: AttachmentCreate,
        file_content: Optional[bytes] = None
    ) -> AttachmentResponse:
        """Create a new attachment for a task"""
        
        # Validate attachment type requirements
        if attachment_data.attachment_type in [AttachmentType.FILE, AttachmentType.IMAGE, AttachmentType.VOICE]:
            if not file_content:
                raise ValueError(f"File content is required for {attachment_data.attachment_type} attachments")
            if not attachment_data.mime_type:
                raise ValueError(f"MIME type is required for {attachment_data.attachment_type} attachments")
        
        if attachment_data.attachment_type == AttachmentType.LINK:
            if not attachment_data.url:
                raise ValueError("URL is required for link attachments")
        
        # Validate file size and type
        if file_content:
            if len(file_content) > self.max_file_size:
                raise ValueError(f"File size exceeds maximum allowed size of {self.max_file_size} bytes")
            
            if attachment_data.mime_type not in self.allowed_mime_types:
                raise ValueError(f"MIME type {attachment_data.mime_type} is not allowed")
        
        # Generate unique ID and storage path
        attachment_id = str(uuid.uuid4())
        
        # Prepare attachment document
        attachment_doc = {
            "id": attachment_id,
            "task_id": task_id,
            "name": attachment_data.name,
            "description": attachment_data.description,
            "attachment_type": attachment_data.attachment_type.value,
            "category": attachment_data.category.value if attachment_data.category else None,
            "uploaded_by": developer_id,
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow(),
            "is_public": False,
            "access_count": 0
        }
        
        # Handle file-based attachments
        if file_content:
            # Calculate file hash for deduplication
            file_hash = hashlib.sha256(file_content).hexdigest()
            file_extension = Path(attachment_data.original_filename or "").suffix.lower()
            
            # Create storage path
            storage_dir = self.storage_base_path / task_id
            storage_dir.mkdir(parents=True, exist_ok=True)
            storage_filename = f"{attachment_id}{file_extension}"
            storage_path = storage_dir / storage_filename
            
            # Save file
            async with aiofiles.open(storage_path, 'wb') as f:
                await f.write(file_content)
            
            # Add file metadata
            attachment_doc.update({
                "file_size": len(file_content),
                "mime_type": attachment_data.mime_type,
                "original_filename": attachment_data.original_filename,
                "file_extension": file_extension.lstrip('.') if file_extension else None,
                "storage_path": str(storage_path.relative_to(self.storage_base_path)),
                "file_hash": file_hash
            })
            
            # Handle image-specific processing
            if attachment_data.attachment_type == AttachmentType.IMAGE:
                try:
                    image_metadata = await self._process_image(file_content, storage_path)
                    attachment_doc.update(image_metadata)
                except Exception as e:
                    logger.warning(f"Failed to process image metadata: {e}")
            
            # Handle voice-specific processing
            elif attachment_data.attachment_type == AttachmentType.VOICE:
                if attachment_data.duration_seconds:
                    attachment_doc["duration_seconds"] = attachment_data.duration_seconds
        
        # Handle link attachments
        elif attachment_data.attachment_type == AttachmentType.LINK:
            if not attachment_data.url:
                raise ValueError("URL is required for link attachments")
            
            try:
                link_metadata = await self._extract_link_metadata(attachment_data.url)
                attachment_doc.update({
                    "url": attachment_data.url,
                    "title": attachment_data.title or link_metadata.get("title"),
                    "favicon_url": attachment_data.favicon_url or link_metadata.get("favicon_url"),
                    "preview_image_url": attachment_data.preview_image_url or link_metadata.get("preview_image_url"),
                    "site_name": attachment_data.site_name or link_metadata.get("site_name")
                })
            except Exception as e:
                logger.warning(f"Failed to extract link metadata: {e}")
                attachment_doc.update({
                    "url": attachment_data.url,
                    "title": attachment_data.title,
                    "favicon_url": attachment_data.favicon_url,
                    "preview_image_url": attachment_data.preview_image_url,
                    "site_name": attachment_data.site_name
                })
        
        # Save to Firestore
        await self.firestore.create_document(self.collection_name, attachment_id, attachment_doc)
        
        # Return response
        return AttachmentResponse(**attachment_doc)
    
    async def get_attachment(self, attachment_id: str, developer_id: str) -> Optional[AttachmentResponse]:
        """Get an attachment by ID"""
        doc = await self.firestore.get_document(self.collection_name, attachment_id)
        if not doc:
            return None
        
        # Increment access count
        await self.firestore.update_document(
            self.collection_name,
            attachment_id,
            {"access_count": doc.get("access_count", 0) + 1}
        )
        
        return AttachmentResponse(**doc)
    
    async def get_task_attachments(
        self,
        task_id: str,
        developer_id: str,
        attachment_type: Optional[AttachmentType] = None,
        category: Optional[AttachmentCategory] = None
    ) -> List[AttachmentResponse]:
        """Get all attachments for a task"""
        
        filters = [("task_id", "==", task_id)]
        
        if attachment_type:
            filters.append(("attachment_type", "==", attachment_type.value))
        
        if category:
            filters.append(("category", "==", category.value))
        
        docs = await self.firestore.query_documents(
            self.collection_name,
            filters=filters,
            order_by=[("created_at", "desc")]
        )
        
        return [AttachmentResponse(**doc) for doc in docs]
    
    async def update_attachment(
        self,
        attachment_id: str,
        developer_id: str,
        update_data: AttachmentUpdate
    ) -> Optional[AttachmentResponse]:
        """Update an attachment's metadata"""
        
        # Get existing attachment
        existing = await self.firestore.get_document(self.collection_name, attachment_id)
        if not existing:
            return None
        
        # Verify ownership (or admin access)
        if existing["uploaded_by"] != developer_id:
            raise ValueError("You can only update attachments you uploaded")
        
        # Prepare update data
        update_dict = update_data.dict(exclude_unset=True)
        if update_dict:
            update_dict["updated_at"] = datetime.utcnow()
            
            # Handle category updates
            if "category" in update_dict and update_dict["category"]:
                update_dict["category"] = update_dict["category"].value
            
            await self.firestore.update_document(self.collection_name, attachment_id, update_dict)
        
        # Return updated attachment
        updated_doc = await self.firestore.get_document(self.collection_name, attachment_id)
        if updated_doc:
            return AttachmentResponse(**updated_doc)
        return None
    
    async def delete_attachment(self, attachment_id: str, developer_id: str) -> bool:
        """Delete an attachment and its associated file"""
        
        # Get attachment
        attachment = await self.firestore.get_document(self.collection_name, attachment_id)
        if not attachment:
            return False
        
        # Verify ownership
        if attachment["uploaded_by"] != developer_id:
            raise ValueError("You can only delete attachments you uploaded")
        
        # Delete file if it exists
        if attachment.get("storage_path"):
            file_path = self.storage_base_path / attachment["storage_path"]
            try:
                await aiofiles.os.remove(file_path)
                
                # Also delete thumbnail if it exists
                if attachment.get("has_thumbnail"):
                    thumbnail_path = file_path.parent / f"thumb_{file_path.name}"
                    if thumbnail_path.exists():
                        await aiofiles.os.remove(thumbnail_path)
                        
            except FileNotFoundError:
                logger.warning(f"File not found when deleting: {file_path}")
            except Exception as e:
                logger.error(f"Error deleting file {file_path}: {e}")
        
        # Delete from Firestore
        await self.firestore.delete_document(self.collection_name, attachment_id)
        return True
    
    async def get_file_content(self, attachment_id: str, developer_id: str) -> Optional[Tuple[bytes, str, str]]:
        """Get file content for download"""
        
        attachment = await self.firestore.get_document(self.collection_name, attachment_id)
        if not attachment or not attachment.get("storage_path"):
            return None
        
        file_path = self.storage_base_path / attachment["storage_path"]
        if not file_path.exists():
            return None
        
        # Read file content
        async with aiofiles.open(file_path, 'rb') as f:
            content = await f.read()
        
        # Return content, filename, and mime type
        return content, attachment["original_filename"], attachment["mime_type"]
    
    async def search_attachments(
        self,
        developer_id: str,
        search_params: AttachmentSearch,
        limit: int = 50,
        offset: int = 0
    ) -> List[AttachmentResponse]:
        """Search attachments with various filters"""
        
        filters = []
        
        # Text search in name and description
        if search_params.query:
            # Note: Firestore doesn't support full-text search, so we'll need to implement this client-side
            # or use a dedicated search service for production
            pass
        
        if search_params.attachment_type:
            filters.append(("attachment_type", "==", search_params.attachment_type.value))
        
        if search_params.category:
            filters.append(("category", "==", search_params.category.value))
        
        if search_params.mime_type:
            filters.append(("mime_type", "==", search_params.mime_type))
        
        if search_params.uploaded_after:
            filters.append(("created_at", ">=", search_params.uploaded_after))
        
        if search_params.uploaded_before:
            filters.append(("created_at", "<=", search_params.uploaded_before))
        
        # Query documents
        docs = await self.firestore.query_documents(
            self.collection_name,
            filters=filters,
            order_by=[("created_at", "desc")],
            limit=limit,
            offset=offset
        )
        
        results = [AttachmentResponse(**doc) for doc in docs]
        
        # Apply client-side filters
        if search_params.query:
            query_lower = search_params.query.lower()
            results = [
                r for r in results 
                if query_lower in r.name.lower() or 
                (r.description and query_lower in r.description.lower())
            ]
        
        if search_params.min_size is not None:
            results = [r for r in results if r.file_size and r.file_size >= search_params.min_size]
        
        if search_params.max_size is not None:
            results = [r for r in results if r.file_size and r.file_size <= search_params.max_size]
        
        if search_params.has_text is not None:
            results = [
                r for r in results 
                if bool(r.extracted_text or r.transcript) == search_params.has_text
            ]
        
        return results
    
    async def get_attachment_stats(self, developer_id: str, task_id: Optional[str] = None) -> AttachmentStats:
        """Get attachment statistics"""
        
        filters = []
        if task_id:
            filters.append(("task_id", "==", task_id))
        
        docs = await self.firestore.query_documents(
            self.collection_name,
            filters=filters
        )
        
        attachments = [AttachmentResponse(**doc) for doc in docs]
        
        # Calculate statistics
        total_attachments = len(attachments)
        total_file_size = sum(a.file_size or 0 for a in attachments)
        
        # Count by type
        by_type = {}
        for attachment in attachments:
            by_type[attachment.attachment_type] = by_type.get(attachment.attachment_type, 0) + 1
        
        # Count by category
        by_category = {}
        for attachment in attachments:
            if attachment.category:
                by_category[attachment.category] = by_category.get(attachment.category, 0) + 1
        
        # Most common types
        most_common_types = [
            {"type": k.value, "count": v} 
            for k, v in sorted(by_type.items(), key=lambda x: x[1], reverse=True)
        ]
        
        # Largest files
        largest_files = sorted(
            [a for a in attachments if a.file_size and a.file_size > 0],
            key=lambda x: x.file_size or 0,
            reverse=True
        )[:10]
        
        # Recent uploads
        recent_uploads = sorted(attachments, key=lambda x: x.created_at, reverse=True)[:10]
        
        return AttachmentStats(
            total_attachments=total_attachments,
            total_file_size=total_file_size,
            by_type=by_type,
            by_category=by_category,
            most_common_types=most_common_types,
            largest_files=largest_files,
            recent_uploads=recent_uploads
        )
    
    async def bulk_delete_attachments(
        self,
        attachment_ids: List[str],
        developer_id: str
    ) -> Dict[str, bool]:
        """Bulk delete multiple attachments"""
        
        results = {}
        for attachment_id in attachment_ids:
            try:
                success = await self.delete_attachment(attachment_id, developer_id)
                results[attachment_id] = success
            except Exception as e:
                logger.error(f"Error deleting attachment {attachment_id}: {e}")
                results[attachment_id] = False
        
        return results
    
    async def _process_image(self, file_content: bytes, storage_path: Path) -> Dict[str, Any]:
        """Process image to extract metadata and create thumbnail"""
        
        if not PIL_AVAILABLE:
            logger.warning("PIL not available, skipping image processing")
            return {}
        
        try:
            # Open image
            image = Image.open(io.BytesIO(file_content))
            
            # Get dimensions
            width, height = image.size
            
            # Create thumbnail
            thumbnail_size = (200, 200)
            thumbnail = ImageOps.fit(image, thumbnail_size, Image.Resampling.LANCZOS)
            
            # Save thumbnail
            thumbnail_path = storage_path.parent / f"thumb_{storage_path.name}"
            thumbnail.save(thumbnail_path, optimize=True, quality=85)
            
            return {
                "width": width,
                "height": height,
                "has_thumbnail": True
            }
            
        except Exception as e:
            logger.error(f"Error processing image: {e}")
            return {}
    
    async def _extract_link_metadata(self, url: str) -> Dict[str, Any]:
        """Extract metadata from a URL"""
        
        if not BS4_AVAILABLE:
            logger.warning("BeautifulSoup not available, skipping link metadata extraction")
            return {}
        
        try:
            # Make request to get page content
            response = requests.get(url, timeout=10, headers={
                'User-Agent': 'TodoApp/1.0'
            })
            response.raise_for_status()
            
            # Parse HTML for metadata
            from bs4 import BeautifulSoup
            soup = BeautifulSoup(response.content, 'html.parser')
            
            metadata = {}
            
            # Extract title
            title_tag = soup.find('title')
            if title_tag:
                metadata['title'] = title_tag.get_text().strip()
            
            # Extract Open Graph data
            og_title = soup.find('meta', property='og:title')
            if og_title:
                metadata['title'] = og_title.get('content', metadata.get('title'))
            
            og_image = soup.find('meta', property='og:image')
            if og_image:
                metadata['preview_image_url'] = og_image.get('content')
            
            og_site_name = soup.find('meta', property='og:site_name')
            if og_site_name:
                metadata['site_name'] = og_site_name.get('content')
            
            # Extract favicon
            favicon = soup.find('link', rel='icon') or soup.find('link', rel='shortcut icon')
            if favicon:
                favicon_url = favicon.get('href')
                if favicon_url:
                    # Make absolute URL
                    metadata['favicon_url'] = urljoin(url, favicon_url)
            
            return metadata
            
        except Exception as e:
            logger.error(f"Error extracting link metadata from {url}: {e}")
            return {}