"""Email service for sending OTP and notifications."""

import logging
from datetime import datetime
from typing import Any, Dict, Optional, Union

try:
    import structlog
    logger = structlog.get_logger(__name__)
    STRUCTLOG_AVAILABLE = True
except ImportError:
    logger = logging.getLogger(__name__)
    STRUCTLOG_AVAILABLE = False

try:
    from sendgrid import SendGridAPIClient
    from sendgrid.helpers.mail import Mail
    SENDGRID_AVAILABLE = True
except ImportError:
    SendGridAPIClient = None
    Mail = None
    SENDGRID_AVAILABLE = False

from app.config import settings


class EmailService:
    """Email service for sending emails via SendGrid or SMTP."""
    
    def __init__(self):
        """Initialize email service."""
        self.sendgrid_client: Optional[Any] = None
        if (SENDGRID_AVAILABLE and 
            settings.email_provider == "sendgrid" and 
            hasattr(settings, 'sendgrid_api_key') and
            SendGridAPIClient is not None):
            self.sendgrid_client = SendGridAPIClient(settings.sendgrid_api_key)
    
    async def send_otp_email(self, email: str, otp: str, developer_name: Optional[str] = None) -> bool:
        """
        Send OTP verification email.
        
        Args:
            email: Recipient email address
            otp: 6-digit OTP code
            developer_name: Optional developer name
        
        Returns:
            True if sent successfully, False otherwise
        """
        subject = "CheckList API - Email Verification"
        
        # HTML email template
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Email Verification - CheckList API</title>
            <style>
                body {{
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    line-height: 1.6;
                    color: #333;
                    max-width: 600px;
                    margin: 0 auto;
                    padding: 20px;
                }}
                .header {{
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 30px;
                    text-align: center;
                    border-radius: 10px 10px 0 0;
                }}
                .content {{
                    background: #f8f9fa;
                    padding: 30px;
                    border-radius: 0 0 10px 10px;
                }}
                .otp-code {{
                    background: #fff;
                    border: 2px solid #667eea;
                    border-radius: 8px;
                    padding: 20px;
                    text-align: center;
                    margin: 20px 0;
                }}
                .otp-number {{
                    font-size: 32px;
                    font-weight: bold;
                    color: #667eea;
                    letter-spacing: 8px;
                    font-family: 'Courier New', monospace;
                }}
                .footer {{
                    text-align: center;
                    margin-top: 30px;
                    color: #666;
                    font-size: 14px;
                }}
                .warning {{
                    background: #fff3cd;
                    border: 1px solid #ffeaa7;
                    border-radius: 5px;
                    padding: 15px;
                    margin: 20px 0;
                    color: #856404;
                }}
            </style>
        </head>
        <body>
            <div class="header">
                <h1>🚀 CheckList API</h1>
                <p>Email Verification Required</p>
            </div>
            <div class="content">
                <h2>Hello{f' {developer_name}' if developer_name else ''}!</h2>
                <p>Thank you for signing up for CheckList API. To complete your registration and verify your email address, please use the verification code below:</p>
                
                <div class="otp-code">
                    <p style="margin: 0; font-weight: bold;">Your Verification Code</p>
                    <div class="otp-number">{otp}</div>
                    <p style="margin: 0; font-size: 14px; color: #666;">This code expires in 10 minutes</p>
                </div>
                
                <div class="warning">
                    <strong>Security Notice:</strong> This code is confidential. Never share it with anyone. CheckList team will never ask for this code.
                </div>
                
                <p>If you didn't request this verification, please ignore this email or contact our support team.</p>
                
                <p>Welcome to the CheckList API developer community!</p>
            </div>
            <div class="footer">
                <p>© 2025 CheckList API. All rights reserved.</p>
                <p>This is an automated email. Please do not reply to this message.</p>
            </div>
        </body>
        </html>
        """
        
        # Plain text version
        text_content = f"""
        CheckList API - Email Verification
        
        Hello{f' {developer_name}' if developer_name else ''}!
        
        Thank you for signing up for CheckList API. To complete your registration and verify your email address, please use the verification code below:
        
        Verification Code: {otp}
        
        This code expires in 10 minutes.
        
        Security Notice: This code is confidential. Never share it with anyone. CheckList team will never ask for this code.
        
        If you didn't request this verification, please ignore this email or contact our support team.
        
        Welcome to the CheckList API developer community!
        
        © 2025 CheckList API. All rights reserved.
        """
        
        return await self._send_email(email, subject, html_content, text_content)
    
    async def send_api_key_created_email(
        self, 
        email: str, 
        developer_name: str, 
        api_key_name: str,
        masked_key: str
    ) -> bool:
        """
        Send notification email when API key is created.
        
        Args:
            email: Developer email
            developer_name: Developer name
            api_key_name: Name of the created API key
            masked_key: Masked API key for security
        
        Returns:
            True if sent successfully, False otherwise
        """
        subject = f"New API Key Created - {api_key_name}"
        
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <style>
                body {{ font-family: Arial, sans-serif; line-height: 1.6; color: #333; }}
                .container {{ max-width: 600px; margin: 0 auto; padding: 20px; }}
                .header {{ background: #28a745; color: white; padding: 20px; text-align: center; }}
                .content {{ padding: 20px; background: #f8f9fa; }}
                .api-key {{ background: #fff; border: 1px solid #ddd; padding: 15px; border-radius: 5px; }}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>🔑 API Key Created</h1>
                </div>
                <div class="content">
                    <h2>Hello {developer_name}!</h2>
                    <p>A new API key has been created for your CheckList API developer account.</p>
                    
                    <div class="api-key">
                        <h3>API Key Details</h3>
                        <p><strong>Name:</strong> {api_key_name}</p>
                        <p><strong>Key:</strong> {masked_key}</p>
                        <p><strong>Created:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} UTC</p>
                    </div>
                    
                    <p><strong>Important Security Notes:</strong></p>
                    <ul>
                        <li>Keep your API key secure and never share it publicly</li>
                        <li>The full API key was only shown once during creation</li>
                        <li>You can manage your API keys in the developer portal</li>
                        <li>Contact support immediately if you suspect unauthorized access</li>
                    </ul>
                    
                    <p>Happy coding!</p>
                </div>
            </div>
        </body>
        </html>
        """
        
        text_content = f"""
        CheckList API - New API Key Created
        
        Hello {developer_name}!
        
        A new API key has been created for your CheckList API developer account.
        
        API Key Details:
        - Name: {api_key_name}
        - Key: {masked_key}
        - Created: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} UTC
        
        Important Security Notes:
        - Keep your API key secure and never share it publicly
        - The full API key was only shown once during creation
        - You can manage your API keys in the developer portal
        - Contact support immediately if you suspect unauthorized access
        
        Happy coding!
        """
        
        return await self._send_email(email, subject, html_content, text_content)
    
    async def _send_email(
        self, 
        to_email: str, 
        subject: str, 
        html_content: str, 
        text_content: str
    ) -> bool:
        """
        Send email using configured provider.
        
        Args:
            to_email: Recipient email
            subject: Email subject
            html_content: HTML email content
            text_content: Plain text email content
        
        Returns:
            True if sent successfully, False otherwise
        """
        try:
            if self.sendgrid_client:
                return await self._send_via_sendgrid(to_email, subject, html_content, text_content)
            else:
                logger.warning("No email provider configured")
                return False
                
        except Exception as e:
            if STRUCTLOG_AVAILABLE:
                logger.error("Failed to send email", error=str(e), to_email=to_email)
            else:
                logger.error(f"Failed to send email to {to_email}: {str(e)}")
            return False
    
    async def _send_via_sendgrid(
        self, 
        to_email: str, 
        subject: str, 
        html_content: str, 
        text_content: str
    ) -> bool:
        """Send email via SendGrid."""
        try:
            if not SENDGRID_AVAILABLE or Mail is None or self.sendgrid_client is None:
                logger.error("SendGrid not available or not configured")
                return False
                
            from_email = getattr(settings, 'from_email', 'noreply@checklist-api.com')
            from_name = getattr(settings, 'from_name', 'CheckList API')
            
            message = Mail(
                from_email=(from_email, from_name),
                to_emails=to_email,
                subject=subject,
                html_content=html_content,
                plain_text_content=text_content
            )
            
            response = self.sendgrid_client.send(message)
            
            if response.status_code == 202:
                if STRUCTLOG_AVAILABLE:
                    logger.info("Email sent successfully", to_email=to_email, subject=subject)
                else:
                    logger.info(f"Email sent successfully to {to_email}")
                return True
            else:
                if STRUCTLOG_AVAILABLE:
                    logger.error(
                        "SendGrid API error", 
                        status_code=response.status_code,
                        to_email=to_email
                    )
                else:
                    logger.error(f"SendGrid API error: {response.status_code} for {to_email}")
                return False
                
        except Exception as e:
            if STRUCTLOG_AVAILABLE:
                logger.error("SendGrid error", error=str(e), to_email=to_email)
            else:
                logger.error(f"SendGrid error for {to_email}: {str(e)}")
            return False


# Global email service instance
email_service = EmailService()