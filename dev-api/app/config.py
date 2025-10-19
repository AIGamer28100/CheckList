"""Configuration settings for the CheckList API."""

from typing import List, Optional
from pydantic import field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""
    
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")
    
    # API Configuration
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_workers: int = 1
    debug: bool = False
    environment: str = "production"
    
    # Security
    secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 30
    
    # Google Cloud / Firestore
    google_application_credentials: Optional[str] = None
    google_cloud_project: str
    firestore_database_id: str = "(default)"
    
    # CORS Settings
    allowed_origins: str = "http://localhost:3000,http://localhost:8080,http://localhost:5173"
    allowed_methods: str = "GET,POST,PUT,PATCH,DELETE,OPTIONS"
    allowed_headers: str = "*"
    
    # Logging
    log_level: str = "INFO"
    log_format: str = "json"
    
    # Rate Limiting
    rate_limit_requests: int = 100
    rate_limit_window: int = 60
    
    # Google OAuth Configuration
    google_oauth_client_id: Optional[str] = None
    google_oauth_client_secret: Optional[str] = None
    google_oauth_redirect_uri: Optional[str] = None
    
    # Mobile Client IDs (for token verification)
    google_android_client_id: Optional[str] = None
    google_ios_client_id: Optional[str] = None
    
    # Email Configuration
    email_provider: str = "smtp"  # "smtp" or "sendgrid"
    sendgrid_api_key: Optional[str] = None
    from_email: str = "noreply@checklist-api.com"
    from_name: str = "CheckList API"
    
    # SMTP Configuration (alternative to SendGrid)
    smtp_server: Optional[str] = None
    smtp_port: int = 587
    smtp_username: Optional[str] = None
    smtp_password: Optional[str] = None
    smtp_use_tls: bool = True
    
    # API Key Configuration
    api_key_length: int = 32
    api_key_prefix: str = "cla_"  # CheckList API prefix
    api_key_default_rate_limit: int = 1000  # requests per hour
    
    # OTP Configuration
    otp_length: int = 6
    otp_expire_minutes: int = 10
    
    # Developer Portal Configuration
    developer_portal_url: str = "http://localhost:3000"
    docs_url: str = "http://localhost:8000/docs"
    
    # Default Rate Limits
    default_rate_limit: int = 1000
    default_quota_monthly: int = 10000
    
    @property
    def cors_origins(self) -> List[str]:
        """Get CORS origins as a list."""
        if isinstance(self.allowed_origins, str):
            return [origin.strip() for origin in self.allowed_origins.split(",") if origin.strip()]
        return self.allowed_origins

    @property 
    def cors_methods(self) -> List[str]:
        """Get CORS methods as a list."""
        if isinstance(self.allowed_methods, str):
            return [method.strip() for method in self.allowed_methods.split(",") if method.strip()]
        return self.allowed_methods

    @property
    def cors_headers(self) -> List[str]:
        """Get CORS headers as a list.""" 
        if isinstance(self.allowed_headers, str):
            return [header.strip() for header in self.allowed_headers.split(",") if header.strip()]
        return self.allowed_headers


# Global settings instance
settings = Settings()