"""Firestore database client for CheckList API."""

import os
from typing import Any, Dict, List, Optional, Type, TypeVar

import firebase_admin
import structlog
from firebase_admin import credentials, firestore
from google.cloud.firestore_v1 import Client
from google.cloud.firestore_v1.base_query import FieldFilter

from app.config import settings

# Type variable for generic document operations
T = TypeVar('T')

logger = structlog.get_logger(__name__)


class FirestoreClient:
    """Firestore database client with connection management."""
    
    def __init__(self) -> None:
        """Initialize Firestore client."""
        self._client: Optional[Client] = None
        self._app: Optional[firebase_admin.App] = None
    
    async def initialize(self) -> None:
        """Initialize Firebase Admin SDK and Firestore client."""
        try:
            # Initialize Firebase Admin SDK
            if settings.google_application_credentials:
                # Use service account key file
                if os.path.exists(settings.google_application_credentials):
                    cred = credentials.Certificate(settings.google_application_credentials)
                    self._app = firebase_admin.initialize_app(cred, {
                        'projectId': settings.google_cloud_project,
                    })
                else:
                    logger.warning(
                        "Service account key file not found, using default credentials",
                        path=settings.google_application_credentials
                    )
                    # Fall back to default credentials (useful for Cloud Run, etc.)
                    self._app = firebase_admin.initialize_app()
            else:
                # Use default credentials (Application Default Credentials)
                self._app = firebase_admin.initialize_app()
            
            # Initialize Firestore client
            self._client = firestore.client(app=self._app)
            
            logger.info(
                "Firestore client initialized successfully",
                project_id=settings.google_cloud_project,
                database_id=settings.firestore_database_id
            )
            
        except Exception as e:
            logger.error("Failed to initialize Firestore client", error=str(e))
            raise
    
    async def close(self) -> None:
        """Close the Firestore client."""
        try:
            if self._app:
                firebase_admin.delete_app(self._app)
                self._app = None
                self._client = None
                logger.info("Firestore client closed successfully")
        except Exception as e:
            logger.error("Error closing Firestore client", error=str(e))
    
    @property
    def client(self) -> Client:
        """Get the Firestore client instance."""
        if not self._client:
            raise RuntimeError("Firestore client not initialized. Call initialize() first.")
        return self._client
    
    async def test_connection(self) -> bool:
        """Test Firestore connection."""
        try:
            # Simple test query
            collections = list(self.client.collections())
            logger.debug("Firestore connection test successful", collections_count=len(collections))
            return True
        except Exception as e:
            logger.error("Firestore connection test failed", error=str(e))
            raise
    
    # Collection operations
    def collection(self, collection_path: str):
        """Get a collection reference."""
        return self.client.collection(collection_path)
    
    # Document operations
    async def create_document(
        self, 
        collection_path: str, 
        document_data: Dict[str, Any],
        document_id: Optional[str] = None
    ) -> str:
        """Create a new document in the specified collection."""
        try:
            collection_ref = self.collection(collection_path)
            
            if document_id:
                doc_ref = collection_ref.document(document_id)
                doc_ref.set(document_data)
                return document_id
            else:
                # Auto-generate document ID
                doc_ref = collection_ref.add(document_data)[1]
                return doc_ref.id
                
        except Exception as e:
            logger.error(
                "Failed to create document",
                collection=collection_path,
                document_id=document_id,
                error=str(e)
            )
            raise
    
    async def get_document(
        self, 
        collection_path: str, 
        document_id: str
    ) -> Optional[Dict[str, Any]]:
        """Get a document by ID."""
        try:
            doc_ref = self.collection(collection_path).document(document_id)
            doc = doc_ref.get()
            
            if doc.exists:
                data = doc.to_dict()
                data['id'] = doc.id
                return data
            return None
            
        except Exception as e:
            logger.error(
                "Failed to get document",
                collection=collection_path,
                document_id=document_id,
                error=str(e)
            )
            raise
    
    async def update_document(
        self, 
        collection_path: str, 
        document_id: str, 
        update_data: Dict[str, Any]
    ) -> None:
        """Update a document."""
        try:
            doc_ref = self.collection(collection_path).document(document_id)
            doc_ref.update(update_data)
            
        except Exception as e:
            logger.error(
                "Failed to update document",
                collection=collection_path,
                document_id=document_id,
                error=str(e)
            )
            raise
    
    async def delete_document(self, collection_path: str, document_id: str) -> None:
        """Delete a document."""
        try:
            doc_ref = self.collection(collection_path).document(document_id)
            doc_ref.delete()
            
        except Exception as e:
            logger.error(
                "Failed to delete document",
                collection=collection_path,
                document_id=document_id,
                error=str(e)
            )
            raise
    
    # Query operations
    async def list_documents(
        self,
        collection_path: str,
        filters: Optional[List[tuple]] = None,
        order_by: Optional[str] = None,
        limit: Optional[int] = None,
        offset: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """List documents with optional filtering, ordering, and pagination."""
        try:
            query = self.collection(collection_path)
            
            # Apply filters
            if filters:
                for field, operator, value in filters:
                    query = query.where(filter=FieldFilter(field, operator, value))
            
            # Apply ordering
            if order_by:
                query = query.order_by(order_by)
            
            # Apply pagination
            if offset:
                query = query.offset(offset)
            
            if limit:
                query = query.limit(limit)
            
            # Execute query
            docs = query.stream()
            
            results = []
            for doc in docs:
                data = doc.to_dict()
                data['id'] = doc.id
                results.append(data)
            
            return results
            
        except Exception as e:
            logger.error(
                "Failed to list documents",
                collection=collection_path,
                filters=filters,
                error=str(e)
            )
            raise
    
    async def count_documents(
        self,
        collection_path: str,
        filters: Optional[List[tuple]] = None
    ) -> int:
        """Count documents in a collection with optional filtering."""
        try:
            query = self.collection(collection_path)
            
            # Apply filters
            if filters:
                for field, operator, value in filters:
                    query = query.where(filter=FieldFilter(field, operator, value))
            
            # Get count
            result = query.count().get()
            return result[0][0].value
            
        except Exception as e:
            logger.error(
                "Failed to count documents",
                collection=collection_path,
                filters=filters,
                error=str(e)
            )
            raise
    
    # Batch operations
    async def batch_write(self, operations: List[Dict[str, Any]]) -> None:
        """Perform batch write operations."""
        try:
            batch = self.client.batch()
            
            for operation in operations:
                op_type = operation['type']
                collection_path = operation['collection']
                document_id = operation['document_id']
                doc_ref = self.collection(collection_path).document(document_id)
                
                if op_type == 'create' or op_type == 'set':
                    batch.set(doc_ref, operation['data'])
                elif op_type == 'update':
                    batch.update(doc_ref, operation['data'])
                elif op_type == 'delete':
                    batch.delete(doc_ref)
            
            batch.commit()
            
        except Exception as e:
            logger.error("Failed to perform batch write", error=str(e))
            raise


# Global Firestore client instance
firestore_client = FirestoreClient()