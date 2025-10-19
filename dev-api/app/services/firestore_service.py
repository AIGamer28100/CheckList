"""Firestore database service for developer platform."""

import logging
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional, Tuple

try:
    from google.cloud import firestore
    from google.cloud.exceptions import NotFound
    FIRESTORE_AVAILABLE = True
except ImportError:
    firestore = None
    NotFound = Exception
    FIRESTORE_AVAILABLE = False

from app.models.developer import (
    Developer,
    DeveloperCreate,
    DeveloperUpdate,
    APIKey,
    APIKeyCreate,
    APIKeyUpdate,
    APIUsageLog,
    DeveloperAnalytics
)
from app.config import settings

logger = logging.getLogger(__name__)


class FirestoreService:
    """Firestore service for managing developer platform data."""
    
    def __init__(self):
        """Initialize Firestore client."""
        self.db: Optional[Any] = None
        if FIRESTORE_AVAILABLE and firestore is not None:
            try:
                if hasattr(settings, 'google_cloud_project'):
                    self.db = firestore.Client(project=settings.google_cloud_project)
                else:
                    self.db = firestore.Client()
                logger.info("Firestore client initialized successfully")
            except Exception as e:
                logger.error(f"Failed to initialize Firestore client: {e}")
                self.db = None
        else:
            logger.warning("Firestore not available - install google-cloud-firestore")
    
    # Developer Management
    
    # Generic Document Operations
    
    async def create_document(self, collection: str, doc_id: str, data: Dict[str, Any]) -> bool:
        """
        Create a document in the specified collection.
        
        Args:
            collection: Collection name
            doc_id: Document ID
            data: Document data
            
        Returns:
            True if created successfully
        """
        if not self.db:
            logger.error("Firestore client not available")
            return False
        
        try:
            doc_ref = self.db.collection(collection).document(doc_id)
            doc_ref.set(data)
            return True
        except Exception as e:
            logger.error(f"Error creating document in {collection}: {e}")
            return False
    
    async def get_document(self, collection: str, doc_id: str) -> Optional[Dict[str, Any]]:
        """
        Get a document from the specified collection.
        
        Args:
            collection: Collection name
            doc_id: Document ID
            
        Returns:
            Document data or None if not found
        """
        if not self.db:
            logger.error("Firestore client not available")
            return None
        
        try:
            doc_ref = self.db.collection(collection).document(doc_id)
            doc = doc_ref.get()
            
            if doc.exists:
                data = doc.to_dict()
                data['id'] = doc.id
                return data
            return None
        except Exception as e:
            logger.error(f"Error getting document from {collection}: {e}")
            return None
    
    async def update_document(self, collection: str, doc_id: str, data: Dict[str, Any]) -> bool:
        """
        Update a document in the specified collection.
        
        Args:
            collection: Collection name
            doc_id: Document ID
            data: Update data
            
        Returns:
            True if updated successfully
        """
        if not self.db:
            logger.error("Firestore client not available")
            return False
        
        try:
            doc_ref = self.db.collection(collection).document(doc_id)
            doc_ref.update(data)
            return True
        except Exception as e:
            logger.error(f"Error updating document in {collection}: {e}")
            return False
    
    async def delete_document(self, collection: str, doc_id: str) -> bool:
        """
        Delete a document from the specified collection.
        
        Args:
            collection: Collection name
            doc_id: Document ID
            
        Returns:
            True if deleted successfully
        """
        if not self.db:
            logger.error("Firestore client not available")
            return False
        
        try:
            doc_ref = self.db.collection(collection).document(doc_id)
            doc_ref.delete()
            return True
        except Exception as e:
            logger.error(f"Error deleting document from {collection}: {e}")
            return False
    
    async def query_documents(
        self, 
        collection: str, 
        filters: Optional[List[Tuple[str, str, Any]]] = None,
        order_by: Optional[List[Tuple[str, str]]] = None,
        limit: Optional[int] = None,
        offset: Optional[int] = None
    ) -> List[Dict[str, Any]]:
        """
        Query documents from a collection with filters, ordering, and pagination.
        
        Args:
            collection: Collection name
            filters: List of (field, operator, value) tuples
            order_by: List of (field, direction) tuples  
            limit: Maximum number of results
            offset: Number of results to skip
            
        Returns:
            List of matching documents
        """
        if not self.db:
            logger.error("Firestore client not available")
            return []
        
        try:
            query = self.db.collection(collection)
            
            # Apply filters
            if filters:
                for field, operator, value in filters:
                    if operator == "in" and isinstance(value, list):
                        # Handle 'in' operator with list values, filtering out None
                        valid_values = [v for v in value if v is not None]
                        if valid_values:
                            query = query.where(field, operator, valid_values)
                        # For None values, add separate equality filter
                        if None in value:
                            query = query.where(field, "==", None)
                    else:
                        query = query.where(field, operator, value)
            
            # Apply ordering
            if order_by:
                for field, direction in order_by:
                    query = query.order_by(field, direction=direction)
            
            # Apply offset
            if offset and offset > 0:
                query = query.offset(offset)
            
            # Apply limit
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
            logger.error(f"Error querying documents from {collection}: {e}")
            return []
    
    async def count_documents(
        self, 
        collection: str, 
        filters: Optional[List[Tuple[str, str, Any]]] = None
    ) -> int:
        """
        Count documents in a collection with optional filters.
        
        Args:
            collection: Collection name
            filters: List of (field, operator, value) tuples
            
        Returns:
            Number of matching documents
        """
        if not self.db:
            logger.error("Firestore client not available")
            return 0
        
        try:
            query = self.db.collection(collection)
            
            # Apply filters
            if filters:
                for field, operator, value in filters:
                    if operator == "in" and isinstance(value, list):
                        # Handle 'in' operator with list values, filtering out None
                        valid_values = [v for v in value if v is not None]
                        if valid_values:
                            query = query.where(field, operator, valid_values)
                        # For None values, add separate equality filter
                        if None in value:
                            query = query.where(field, "==", None)
                    else:
                        query = query.where(field, operator, value)
            
            # Get count (Note: This might not be the most efficient for large collections)
            docs = query.stream()
            count = sum(1 for _ in docs)
            
            return count
        except Exception as e:
            logger.error(f"Error counting documents in {collection}: {e}")
            return 0
    async def create_developer(self, developer_data: DeveloperCreate) -> Optional[Developer]:
        """Create a new developer account."""
        if not self.db:
            logger.error("Firestore not available")
            return None
        
        try:
            # Check if developer already exists
            existing = await self.get_developer_by_email(developer_data.email)
            if existing:
                logger.warning(f"Developer with email {developer_data.email} already exists")
                return None
            
            # Create developer document
            developer_ref = self.db.collection('developers').document()
            developer_id = developer_ref.id
            
            now = datetime.now(timezone.utc)
            developer_dict = {
                'id': developer_id,
                'email': developer_data.email,
                'full_name': developer_data.full_name,
                'company_name': developer_data.company_name,
                'website_url': developer_data.website_url,
                'description': developer_data.description,
                'status': developer_data.status,
                'email_verified': False,
                'is_active': True,
                'created_at': now,
                'updated_at': now,
                'last_login': None,
                'google_id': developer_data.google_id,
                'avatar_url': developer_data.avatar_url
            }
            
            developer_ref.set(developer_dict)
            
            # Initialize developer analytics
            analytics_ref = self.db.collection('developer_analytics').document(developer_id)
            analytics_data = {
                'developer_id': developer_id,
                'total_requests': 0,
                'successful_requests': 0,
                'failed_requests': 0,
                'total_api_keys': 0,
                'last_request_date': None,
                'requests_this_month': 0,
                'requests_today': 0,
                'created_at': now,
                'updated_at': now
            }
            analytics_ref.set(analytics_data)
            
            return Developer(**developer_dict)
            
        except Exception as e:
            logger.error(f"Error creating developer: {e}")
            return None
    
    async def get_developer_by_id(self, developer_id: str) -> Optional[Developer]:
        """Get developer by ID."""
        if not self.db:
            return None
        
        try:
            doc_ref = self.db.collection('developers').document(developer_id)
            doc = doc_ref.get()
            
            if doc.exists:
                return Developer(**doc.to_dict())
            return None
            
        except Exception as e:
            logger.error(f"Error getting developer by ID: {e}")
            return None
    
    async def get_developer_by_email(self, email: str) -> Optional[Developer]:
        """Get developer by email."""
        if not self.db:
            return None
        
        try:
            docs = self.db.collection('developers').where('email', '==', email).limit(1).stream()
            
            for doc in docs:
                return Developer(**doc.to_dict())
            return None
            
        except Exception as e:
            logger.error(f"Error getting developer by email: {e}")
            return None
    
    async def get_developer_by_oauth(self, oauth_provider: str, oauth_id: str) -> Optional[Developer]:
        """Get developer by OAuth provider and ID."""
        if not self.db:
            return None
        
        try:
            docs = (self.db.collection('developers')
                   .where('oauth_provider', '==', oauth_provider)
                   .where('oauth_id', '==', oauth_id)
                   .limit(1)
                   .stream())
            
            for doc in docs:
                return Developer(**doc.to_dict())
            return None
            
        except Exception as e:
            logger.error(f"Error getting developer by OAuth: {e}")
            return None
    
    async def update_developer(self, developer_id: str, update_data: DeveloperUpdate) -> Optional[Developer]:
        """Update developer information."""
        if not self.db:
            return None
        
        try:
            doc_ref = self.db.collection('developers').document(developer_id)
            
            # Prepare update data
            update_dict = {}
            for field, value in update_data.dict(exclude_unset=True).items():
                if value is not None:
                    update_dict[field] = value
            
            update_dict['updated_at'] = datetime.now(timezone.utc)
            
            doc_ref.update(update_dict)
            
            # Get updated document
            return await self.get_developer_by_id(developer_id)
            
        except Exception as e:
            logger.error(f"Error updating developer: {e}")
            return None
    
    async def verify_developer_email(self, developer_id: str) -> bool:
        """Mark developer email as verified."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('developers').document(developer_id)
            doc_ref.update({
                'email_verified': True,
                'verification_token': None,
                'verification_token_expires': None,
                'updated_at': datetime.now(timezone.utc)
            })
            return True
            
        except Exception as e:
            logger.error(f"Error verifying developer email: {e}")
            return False
    
    # API Key Management
    async def create_api_key(self, developer_id: str, api_key_data: APIKeyCreate) -> Optional[APIKey]:
        """Create a new API key for developer."""
        if not self.db:
            return None
        
        try:
            # Generate the actual API key
            from app.utils.security import generate_api_key
            api_key = generate_api_key()
            
            # Create API key document
            api_key_ref = self.db.collection('api_keys').document()
            api_key_id = api_key_ref.id
            
            now = datetime.now(timezone.utc)
            api_key_dict = {
                'id': api_key_id,
                'key': api_key,
                'developer_id': developer_id,
                'name': api_key_data.name,
                'description': api_key_data.description,
                'permissions': api_key_data.permissions,
                'rate_limit': api_key_data.rate_limit,
                'monthly_quota': api_key_data.monthly_quota,
                'allowed_origins': api_key_data.allowed_origins,
                'webhook_url': api_key_data.webhook_url,
                'status': api_key_data.status,
                'created_at': now,
                'updated_at': now,
                'last_used': None,
                'usage_count': 0,
                'current_month_usage': 0
            }
            
            api_key_ref.set(api_key_dict)
            
            # Update developer analytics
            await self._update_developer_api_key_count(developer_id, 1)
            
            return APIKey(**api_key_dict)
            
        except Exception as e:
            logger.error(f"Error creating API key: {e}")
            return None
    
    async def get_api_keys_by_developer(self, developer_id: str) -> List[APIKey]:
        """Get all API keys for a developer."""
        if not self.db:
            return []
        
        try:
            docs = (self.db.collection('api_keys')
                   .where('developer_id', '==', developer_id)
                   .order_by('created_at', direction=firestore.Query.DESCENDING)
                   .stream())
            
            api_keys = []
            for doc in docs:
                api_keys.append(APIKey(**doc.to_dict()))
            
            return api_keys
            
        except Exception as e:
            logger.error(f"Error getting API keys: {e}")
            return []
    
    async def get_api_key_by_hash(self, key_hash: str) -> Optional[APIKey]:
        """Get API key by hash."""
        if not self.db:
            return None
        
        try:
            docs = (self.db.collection('api_keys')
                   .where('key_hash', '==', key_hash)
                   .where('is_active', '==', True)
                   .limit(1)
                   .stream())
            
            for doc in docs:
                return APIKey(**doc.to_dict())
            return None
            
        except Exception as e:
            logger.error(f"Error getting API key by hash: {e}")
            return None
    
    async def update_api_key_usage(self, api_key_id: str) -> bool:
        """Update API key usage statistics."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('api_keys').document(api_key_id)
            doc_ref.update({
                'last_used': datetime.now(timezone.utc),
                'usage_count': firestore.Increment(1)
            })
            return True
            
        except Exception as e:
            logger.error(f"Error updating API key usage: {e}")
            return False
    
    async def deactivate_api_key(self, api_key_id: str) -> bool:
        """Deactivate an API key."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('api_keys').document(api_key_id)
            doc_ref.update({
                'is_active': False,
                'updated_at': datetime.now(timezone.utc)
            })
            return True
            
        except Exception as e:
            logger.error(f"Error deactivating API key: {e}")
            return False
    
    # Usage Logging
    async def log_api_usage(self, usage_data: APIUsageLog) -> bool:
        """Log API usage."""
        if not self.db:
            return False
        
        try:
            # Create usage log document
            log_ref = self.db.collection('api_usage_logs').document()
            
            usage_dict = {
                'id': log_ref.id,
                'api_key_id': usage_data.api_key_id,
                'developer_id': usage_data.developer_id,
                'endpoint': usage_data.endpoint,
                'method': usage_data.method,
                'status_code': usage_data.status_code,
                'response_time_ms': usage_data.response_time_ms,
                'request_size_bytes': usage_data.request_size,
                'response_size_bytes': usage_data.response_size,
                'user_agent': usage_data.user_agent,
                'ip_address': usage_data.ip_address,
                'timestamp': usage_data.timestamp or datetime.now(timezone.utc),
                'error_message': usage_data.error_message
            }
            
            log_ref.set(usage_dict)
            
            # Update analytics
            await self._update_developer_analytics(
                usage_data.developer_id,
                usage_data.status_code < 400
            )
            
            return True
            
        except Exception as e:
            logger.error(f"Error logging API usage: {e}")
            return False
    
    # Analytics
    async def get_developer_analytics(self, developer_id: str) -> Optional[DeveloperAnalytics]:
        """Get developer analytics."""
        if not self.db:
            return None
        
        try:
            doc_ref = self.db.collection('developer_analytics').document(developer_id)
            doc = doc_ref.get()
            
            if doc.exists:
                return DeveloperAnalytics(**doc.to_dict())
            return None
            
        except Exception as e:
            logger.error(f"Error getting developer analytics: {e}")
            return None
    
    async def get_usage_logs(
        self, 
        developer_id: str, 
        limit: int = 100,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None
    ) -> List[APIUsageLog]:
        """Get usage logs for a developer."""
        if not self.db:
            return []
        
        try:
            query = (self.db.collection('api_usage_logs')
                    .where('developer_id', '==', developer_id)
                    .order_by('timestamp', direction=firestore.Query.DESCENDING)
                    .limit(limit))
            
            if start_date:
                query = query.where('timestamp', '>=', start_date)
            if end_date:
                query = query.where('timestamp', '<=', end_date)
            
            docs = query.stream()
            
            logs = []
            for doc in docs:
                logs.append(APIUsageLog(**doc.to_dict()))
            
            return logs
            
        except Exception as e:
            logger.error(f"Error getting usage logs: {e}")
            return []
    
    # Private helper methods
    async def _update_developer_analytics(self, developer_id: str, success: bool) -> None:
        """Update developer analytics."""
        try:
            # Skip analytics for anonymous users
            if developer_id == "anonymous":
                return
                
            doc_ref = self.db.collection('developer_analytics').document(developer_id)
            
            # Check if document exists, create if it doesn't
            doc = doc_ref.get()
            if not doc.exists:
                # Create initial analytics document
                initial_data = {
                    'developer_id': developer_id,
                    'total_requests': 0,
                    'successful_requests': 0,
                    'failed_requests': 0,
                    'requests_today': 0,
                    'requests_this_month': 0,
                    'created_at': datetime.now(timezone.utc),
                    'updated_at': datetime.now(timezone.utc),
                    'last_request_date': datetime.now(timezone.utc)
                }
                doc_ref.set(initial_data)
            
            # Now update with increments
            updates = {
                'total_requests': firestore.Increment(1),
                'last_request_date': datetime.now(timezone.utc),
                'requests_today': firestore.Increment(1),
                'requests_this_month': firestore.Increment(1),
                'updated_at': datetime.now(timezone.utc)
            }
            
            if success:
                updates['successful_requests'] = firestore.Increment(1)
            else:
                updates['failed_requests'] = firestore.Increment(1)
            
            doc_ref.update(updates)
            
        except Exception as e:
            logger.error(f"Error updating developer analytics: {e}")
    
    async def _update_developer_api_key_count(self, developer_id: str, increment: int) -> None:
        """Update developer API key count."""
        try:
            doc_ref = self.db.collection('developer_analytics').document(developer_id)
            doc_ref.update({
                'total_api_keys': firestore.Increment(increment),
                'updated_at': datetime.now(timezone.utc)
            })
            
        except Exception as e:
            logger.error(f"Error updating API key count: {e}")

    # Consent Management
    async def create_consent_request(self, consent_request) -> bool:
        """Create a new consent request."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('consent_requests').document(consent_request.id)
            doc_ref.set(consent_request.model_dump())
            logger.info(f"Created consent request: {consent_request.id}")
            return True
            
        except Exception as e:
            logger.error(f"Error creating consent request: {e}")
            return False

    async def get_consent_request(self, consent_id: str):
        """Get a consent request by ID."""
        if not self.db:
            return None
        
        try:
            from app.models.consent import ConsentRequest
            doc_ref = self.db.collection('consent_requests').document(consent_id)
            doc = doc_ref.get()
            
            if doc.exists:
                data = doc.to_dict()
                return ConsentRequest(**data)
            return None
            
        except Exception as e:
            logger.error(f"Error getting consent request {consent_id}: {e}")
            return None

    async def update_consent_request(self, consent_request) -> bool:
        """Update a consent request."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('consent_requests').document(consent_request.id)
            doc_ref.update(consent_request.model_dump())
            logger.info(f"Updated consent request: {consent_request.id}")
            return True
            
        except Exception as e:
            logger.error(f"Error updating consent request: {e}")
            return False

    async def create_consent_grant(self, grant) -> bool:
        """Create a new consent grant."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('consent_grants').document(grant.id)
            doc_ref.set(grant.model_dump())
            logger.info(f"Created consent grant: {grant.id}")
            return True
            
        except Exception as e:
            logger.error(f"Error creating consent grant: {e}")
            return False

    async def get_consent_grant(self, grant_id: str):
        """Get a consent grant by ID."""
        if not self.db:
            return None
        
        try:
            from app.models.consent import ConsentGrant
            doc_ref = self.db.collection('consent_grants').document(grant_id)
            doc = doc_ref.get()
            
            if doc.exists:
                data = doc.to_dict()
                return ConsentGrant(**data)
            return None
            
        except Exception as e:
            logger.error(f"Error getting consent grant {grant_id}: {e}")
            return None

    async def update_consent_grant(self, grant) -> bool:
        """Update a consent grant."""
        if not self.db:
            return False
        
        try:
            doc_ref = self.db.collection('consent_grants').document(grant.id)
            doc_ref.update(grant.model_dump())
            logger.info(f"Updated consent grant: {grant.id}")
            return True
            
        except Exception as e:
            logger.error(f"Error updating consent grant: {e}")
            return False

    async def get_developer_consent_grants(self, developer_id: str) -> List:
        """Get all consent grants for a developer."""
        if not self.db:
            return []
        
        try:
            from app.models.consent import ConsentGrant
            grants = []
            docs = self.db.collection('consent_grants').where('developer_id', '==', developer_id).stream()
            
            for doc in docs:
                data = doc.to_dict()
                grants.append(ConsentGrant(**data))
            
            logger.info(f"Retrieved {len(grants)} consent grants for developer: {developer_id}")
            return grants
            
        except Exception as e:
            logger.error(f"Error getting consent grants for developer {developer_id}: {e}")
            return []

    async def get_api_usage_logs(
        self, 
        developer_id: Optional[str] = None, 
        limit: int = 100,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None,
        endpoint: Optional[str] = None
    ) -> List[APIUsageLog]:
        """Get API usage logs with filters."""
        if not self.db:
            return []
        
        try:
            query = self.db.collection('api_usage_logs')
            
            if developer_id:
                query = query.where('developer_id', '==', developer_id)
            if endpoint:
                query = query.where('endpoint', '==', endpoint)
            if start_date:
                query = query.where('timestamp', '>=', start_date)
            if end_date:
                query = query.where('timestamp', '<=', end_date)
            
            if FIRESTORE_AVAILABLE and firestore:
                query = query.order_by('timestamp', direction=firestore.Query.DESCENDING).limit(limit)
            else:
                query = query.limit(limit)
            
            logs = []
            docs = query.stream()
            
            for doc in docs:
                data = doc.to_dict()
                logs.append(APIUsageLog(**data))
            
            return logs
            
        except Exception as e:
            logger.error(f"Error getting API usage logs: {e}")
            return []

    async def get_developer_api_keys(self, developer_id: str) -> List[dict]:
        """Get all API keys for a developer."""
        if not self.db:
            return []
        
        try:
            docs = self.db.collection('api_keys').where('developer_id', '==', developer_id).stream()
            
            api_keys = []
            for doc in docs:
                data = doc.to_dict()
                api_keys.append(data)
            
            return api_keys
            
        except Exception as e:
            logger.error(f"Error getting developer API keys: {e}")
            return []


# Global Firestore service instance
firestore_service = FirestoreService()