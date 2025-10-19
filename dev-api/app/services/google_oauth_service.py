"""Google OAuth authentication service."""

import logging
from datetime import datetime, timedelta, timezone
from typing import Dict, Optional, Tuple

try:
    from google.auth.transport import requests as google_requests
    from google.oauth2 import id_token
    import requests
    GOOGLE_AUTH_AVAILABLE = True
except ImportError:
    google_requests = None
    id_token = None
    requests = None
    GOOGLE_AUTH_AVAILABLE = False

from app.config import settings
from app.models.developer import DeveloperCreate, DeveloperUpdate
from app.services.firestore_service import firestore_service
from app.utils.security import generate_verification_token, generate_otp

logger = logging.getLogger(__name__)


class GoogleOAuthService:
    """Google OAuth service for developer authentication."""
    
    def __init__(self):
        """Initialize Google OAuth service."""
        self.client_id = getattr(settings, 'google_oauth_client_id', None)
        self.client_secret = getattr(settings, 'google_oauth_client_secret', None)
        self.redirect_uri = getattr(settings, 'google_oauth_redirect_uri', None)
        
        self.enabled = (
            GOOGLE_AUTH_AVAILABLE and 
            self.client_id and 
            self.client_secret and 
            self.redirect_uri
        )
        
        if not self.enabled:
            logger.warning("Google OAuth not fully configured")
    
    def get_auth_url(self, state: Optional[str] = None) -> Optional[str]:
        """
        Generate Google OAuth authorization URL.
        
        Args:
            state: Optional state parameter for CSRF protection
        
        Returns:
            Authorization URL or None if not configured
        """
        if not self.enabled:
            return None
        
        base_url = "https://accounts.google.com/o/oauth2/v2/auth"
        params = {
            'client_id': self.client_id,
            'redirect_uri': self.redirect_uri,
            'scope': 'openid email profile',
            'response_type': 'code',
            'access_type': 'offline',
            'include_granted_scopes': 'true'
        }
        
        if state:
            params['state'] = state
        
        # Build URL
        query_string = '&'.join([f"{k}={v}" for k, v in params.items()])
        return f"{base_url}?{query_string}"
    
    async def exchange_code_for_tokens(self, code: str) -> Optional[Dict]:
        """
        Exchange authorization code for access tokens.
        
        Args:
            code: Authorization code from Google
        
        Returns:
            Token response or None if failed
        """
        if not self.enabled or not requests:
            return None
        
        try:
            token_url = "https://oauth2.googleapis.com/token"
            data = {
                'client_id': self.client_id,
                'client_secret': self.client_secret,
                'code': code,
                'grant_type': 'authorization_code',
                'redirect_uri': self.redirect_uri
            }
            
            response = requests.post(token_url, data=data)
            response.raise_for_status()
            
            return response.json()
            
        except Exception as e:
            logger.error(f"Error exchanging code for tokens: {e}")
            return None
    
    async def verify_id_token(self, id_token_str: str) -> Optional[Dict]:
        """
        Verify Google ID token and extract user info.
        
        Args:
            id_token_str: ID token from Google
        
        Returns:
            User info or None if verification failed
        """
        if not self.enabled or not id_token or not google_requests:
            return None
        
        try:
            # Create a request object
            request = google_requests.Request()
            
            # Verify the token
            user_info = id_token.verify_oauth2_token(
                id_token_str, 
                request, 
                self.client_id
            )
            
            # Verify the issuer
            if user_info['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
                logger.error("Invalid token issuer")
                return None
            
            return user_info
            
        except Exception as e:
            logger.error(f"Error verifying ID token: {e}")
            return None
    
    async def authenticate_developer(
        self, 
        code: str,
        state: Optional[str] = None
    ) -> Tuple[Optional[str], Optional[str]]:
        """
        Authenticate developer using Google OAuth.
        
        Args:
            code: Authorization code from Google
            state: Optional state parameter for verification
        
        Returns:
            Tuple of (developer_id, error_message)
        """
        try:
            # Exchange code for tokens
            tokens = await self.exchange_code_for_tokens(code)
            if not tokens:
                return None, "Failed to exchange authorization code"
            
            # Verify ID token and get user info
            id_token_value = tokens.get('id_token')
            if not id_token_value:
                return None, "No ID token received"
                
            user_info = await self.verify_id_token(id_token_value)
            if not user_info:
                return None, "Failed to verify ID token"
            
            # Extract user information
            email = user_info.get('email')
            name = user_info.get('name')
            oauth_id = user_info.get('sub')
            
            if not email or not oauth_id:
                return None, "Missing required user information"
            
            # Check if developer already exists
            existing_developer = await firestore_service.get_developer_by_oauth('google', oauth_id)
            if existing_developer:
                # Update last login
                update_data = DeveloperUpdate(last_login=datetime.now(timezone.utc))
                await firestore_service.update_developer(existing_developer.id, update_data)
                return existing_developer.id, None
            
            # Check if developer exists with same email but different OAuth
            existing_by_email = await firestore_service.get_developer_by_email(email)
            if existing_by_email:
                return None, "Account with this email already exists with different authentication method"
            
            # Create new developer
            verification_token, expires_at = generate_verification_token()
            
            developer_data = DeveloperCreate(
                email=email,
                name=name or email.split('@')[0],
                oauth_provider='google',
                oauth_id=oauth_id,
                verification_token=verification_token,
                verification_token_expires=expires_at
            )
            
            developer = await firestore_service.create_developer(developer_data)
            if not developer:
                return None, "Failed to create developer account"
            
            # Since this is OAuth, we can mark email as verified
            await firestore_service.verify_developer_email(developer.id)
            
            return developer.id, None
            
        except Exception as e:
            logger.error(f"Error authenticating developer: {e}")
            return None, "Authentication failed"
    
    async def get_user_info(self, access_token: str) -> Optional[Dict]:
        """
        Get user information using access token.
        
        Args:
            access_token: Google access token
        
        Returns:
            User info or None if failed
        """
        if not self.enabled or not requests:
            return None
        
        try:
            headers = {'Authorization': f'Bearer {access_token}'}
            response = requests.get(
                'https://www.googleapis.com/oauth2/v2/userinfo',
                headers=headers
            )
            response.raise_for_status()
            
            return response.json()
            
        except Exception as e:
            logger.error(f"Error getting user info: {e}")
            return None
    
    def is_configured(self) -> bool:
        """Check if Google OAuth is properly configured."""
        return bool(self.enabled)


# Global Google OAuth service instance
google_oauth_service = GoogleOAuthService()