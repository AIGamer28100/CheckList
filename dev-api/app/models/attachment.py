"""
Pydantic models for task attachments
"""
from datetime import datetime
from typing import Optional, Dict, Any, List
from pydantic import BaseModel, Field, validator
from enum import Enum
import mimetypes
import uuid


class AttachmentType(str, Enum):
    """Supported attachment types"""
    FILE = "file"
    IMAGE = "image"
    VOICE = "voice"
    LINK = "link"


class AttachmentCategory(str, Enum):
    """Categories for organizing attachments"""
    DOCUMENT = "document"
    SPREADSHEET = "spreadsheet"
    PRESENTATION = "presentation"
    PDF = "pdf"
    IMAGE = "image"
    VIDEO = "video"
    AUDIO = "audio"
    ARCHIVE = "archive"
    CODE = "code"
    OTHER = "other"


class AttachmentBase(BaseModel):
    """Base attachment model with common fields"""
    name: str = Field(..., min_length=1, max_length=255, description="Attachment name")
    description: Optional[str] = Field(None, max_length=1000, description="Optional attachment description")
    attachment_type: AttachmentType = Field(..., description="Type of attachment")
    category: Optional[AttachmentCategory] = Field(None, description="Attachment category")
    
    @validator('name')
    def validate_name(cls, v):
        if not v or not v.strip():
            raise ValueError('Attachment name cannot be empty')
        return v.strip()


class FileAttachmentBase(AttachmentBase):
    """Base model for file-based attachments"""
    file_size: int = Field(..., ge=0, description="File size in bytes")
    mime_type: str = Field(..., description="MIME type of the file")
    original_filename: str = Field(..., description="Original filename when uploaded")
    file_extension: Optional[str] = Field(None, description="File extension")
    
    @validator('file_extension', pre=True, always=True)
    def set_file_extension(cls, v, values):
        if v:
            return v.lower()
        # Extract from original filename if not provided
        filename = values.get('original_filename', '')
        if '.' in filename:
            return filename.split('.')[-1].lower()
        return None
    
    @validator('category', pre=True, always=True)
    def auto_categorize(cls, v, values):
        if v:
            return v
        
        # Auto-categorize based on MIME type
        mime_type = values.get('mime_type', '').lower()
        file_ext = values.get('file_extension', '').lower()
        
        if mime_type.startswith('image/'):
            return AttachmentCategory.IMAGE
        elif mime_type.startswith('video/'):
            return AttachmentCategory.VIDEO
        elif mime_type.startswith('audio/'):
            return AttachmentCategory.AUDIO
        elif mime_type == 'application/pdf':
            return AttachmentCategory.PDF
        elif mime_type in ['application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']:
            return AttachmentCategory.DOCUMENT
        elif mime_type in ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']:
            return AttachmentCategory.SPREADSHEET
        elif mime_type in ['application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation']:
            return AttachmentCategory.PRESENTATION
        elif mime_type in ['application/zip', 'application/x-rar-compressed', 'application/x-tar', 'application/gzip']:
            return AttachmentCategory.ARCHIVE
        elif file_ext in ['py', 'js', 'ts', 'java', 'cpp', 'c', 'html', 'css', 'json', 'xml', 'yaml', 'yml']:
            return AttachmentCategory.CODE
        else:
            return AttachmentCategory.OTHER


class ImageAttachmentBase(FileAttachmentBase):
    """Base model for image attachments with additional metadata"""
    width: Optional[int] = Field(None, ge=1, description="Image width in pixels")
    height: Optional[int] = Field(None, ge=1, description="Image height in pixels")
    has_thumbnail: bool = Field(default=False, description="Whether thumbnail is available")
    extracted_text: Optional[str] = Field(None, description="OCR extracted text from image")
    
    @validator('attachment_type', pre=True, always=True)
    def set_image_type(cls, v):
        return AttachmentType.IMAGE


class VoiceAttachmentBase(FileAttachmentBase):
    """Base model for voice/audio attachments"""
    duration_seconds: Optional[float] = Field(None, ge=0, description="Audio duration in seconds")
    transcript: Optional[str] = Field(None, description="Speech-to-text transcript")
    language: Optional[str] = Field(None, description="Detected language code")
    
    @validator('attachment_type', pre=True, always=True)
    def set_voice_type(cls, v):
        return AttachmentType.VOICE


class LinkAttachmentBase(AttachmentBase):
    """Base model for link attachments"""
    url: str = Field(..., description="The URL being attached")
    title: Optional[str] = Field(None, description="Page title from metadata")
    favicon_url: Optional[str] = Field(None, description="URL to the site's favicon")
    preview_image_url: Optional[str] = Field(None, description="URL to preview image")
    site_name: Optional[str] = Field(None, description="Name of the site")
    
    @validator('attachment_type', pre=True, always=True)
    def set_link_type(cls, v):
        return AttachmentType.LINK


class AttachmentCreate(BaseModel):
    """Model for creating new attachments"""
    name: str = Field(..., min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=1000)
    attachment_type: AttachmentType
    category: Optional[AttachmentCategory] = None
    
    # File-specific fields
    file_size: Optional[int] = Field(None, ge=0)
    mime_type: Optional[str] = None
    original_filename: Optional[str] = None
    
    # Image-specific fields
    width: Optional[int] = Field(None, ge=1)
    height: Optional[int] = Field(None, ge=1)
    
    # Voice-specific fields
    duration_seconds: Optional[float] = Field(None, ge=0)
    
    # Link-specific fields
    url: Optional[str] = None
    title: Optional[str] = None
    favicon_url: Optional[str] = None
    preview_image_url: Optional[str] = None
    site_name: Optional[str] = None


class AttachmentUpdate(BaseModel):
    """Model for updating existing attachments"""
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    description: Optional[str] = Field(None, max_length=1000)
    category: Optional[AttachmentCategory] = None
    
    # OCR/transcript updates
    extracted_text: Optional[str] = None
    transcript: Optional[str] = None
    language: Optional[str] = None
    
    # Link metadata updates
    title: Optional[str] = None
    favicon_url: Optional[str] = None
    preview_image_url: Optional[str] = None
    site_name: Optional[str] = None


class AttachmentResponse(BaseModel):
    """Model for attachment responses"""
    id: str = Field(..., description="Unique attachment identifier")
    task_id: str = Field(..., description="ID of the parent task")
    name: str
    description: Optional[str] = None
    attachment_type: AttachmentType
    category: Optional[AttachmentCategory] = None
    
    # File metadata
    file_size: Optional[int] = None
    mime_type: Optional[str] = None
    original_filename: Optional[str] = None
    file_extension: Optional[str] = None
    storage_path: Optional[str] = None
    download_url: Optional[str] = None
    
    # Image metadata
    width: Optional[int] = None
    height: Optional[int] = None
    has_thumbnail: bool = False
    thumbnail_url: Optional[str] = None
    extracted_text: Optional[str] = None
    
    # Voice metadata
    duration_seconds: Optional[float] = None
    transcript: Optional[str] = None
    language: Optional[str] = None
    
    # Link metadata
    url: Optional[str] = None
    title: Optional[str] = None
    favicon_url: Optional[str] = None
    preview_image_url: Optional[str] = None
    site_name: Optional[str] = None
    
    # Timestamps and metadata
    created_at: datetime
    updated_at: datetime
    uploaded_by: str = Field(..., description="ID of the developer who uploaded")
    is_public: bool = Field(default=False, description="Whether attachment is publicly accessible")
    access_count: int = Field(default=0, description="Number of times attachment was accessed")
    
    # Computed fields
    @property
    def file_size_human(self) -> Optional[str]:
        """Human-readable file size"""
        if not self.file_size:
            return None
        
        size = self.file_size
        for unit in ['B', 'KB', 'MB', 'GB']:
            if size < 1024.0:
                return f"{size:.1f} {unit}"
            size /= 1024.0
        return f"{size:.1f} TB"
    
    @property
    def duration_human(self) -> Optional[str]:
        """Human-readable duration for audio/video"""
        if not self.duration_seconds:
            return None
        
        seconds = int(self.duration_seconds)
        minutes = seconds // 60
        seconds = seconds % 60
        
        if minutes > 60:
            hours = minutes // 60
            minutes = minutes % 60
            return f"{hours}:{minutes:02d}:{seconds:02d}"
        else:
            return f"{minutes}:{seconds:02d}"


class AttachmentStats(BaseModel):
    """Statistics about attachments"""
    total_attachments: int = 0
    total_file_size: int = 0
    by_type: Dict[AttachmentType, int] = Field(default_factory=dict)
    by_category: Dict[AttachmentCategory, int] = Field(default_factory=dict)
    most_common_types: List[Dict[str, Any]] = Field(default_factory=list)
    largest_files: List[AttachmentResponse] = Field(default_factory=list)
    recent_uploads: List[AttachmentResponse] = Field(default_factory=list)


class BulkAttachmentOperation(BaseModel):
    """Model for bulk operations on attachments"""
    attachment_ids: List[str] = Field(..., description="List of attachment IDs")
    operation: str = Field(..., description="Operation to perform")
    
    @validator('attachment_ids')
    def validate_attachment_ids(cls, v):
        if not v or len(v) < 1:
            raise ValueError('At least one attachment ID is required')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "attachment_ids": ["uuid1", "uuid2", "uuid3"],
                "operation": "delete"
            }
        }


class AttachmentSearch(BaseModel):
    """Model for searching attachments"""
    query: Optional[str] = Field(None, description="Search query for name/description")
    attachment_type: Optional[AttachmentType] = None
    category: Optional[AttachmentCategory] = None
    mime_type: Optional[str] = None
    min_size: Optional[int] = Field(None, ge=0)
    max_size: Optional[int] = Field(None, ge=0)
    has_text: Optional[bool] = None  # Has OCR text or transcript
    uploaded_after: Optional[datetime] = None
    uploaded_before: Optional[datetime] = None
    
    class Config:
        schema_extra = {
            "example": {
                "query": "meeting notes",
                "attachment_type": "file",
                "category": "document",
                "has_text": True
            }
        }