"""OAuth-like consent system router."""

import uuid
from datetime import datetime, timezone, timedelta
from typing import Optional

from fastapi import APIRouter, Depends, HTTPException, Request, Query, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates

from app.dependencies.auth import get_current_developer
from app.models.consent import (
    ConsentRequest,
    ConsentRequestCreate,
    ConsentRequestResponse,
    ConsentResponse,
    ConsentGrant,
    ConsentGrantCreate,
    ConsentGrantResponse,
    ConsentGrantListResponse,
    ConsentStatus,
    ConsentScope
)
from app.models.developer import Developer
from app.services.firestore_service import firestore_service

router = APIRouter(prefix="/consent", tags=["OAuth Consent"])

# In a real application, you'd use a proper template engine
# For now, we'll return basic HTML responses


@router.post("/authorize", response_model=ConsentRequestResponse)
async def create_consent_request(
    request: ConsentRequestCreate,
    current_developer: Developer = Depends(get_current_developer)
):
    """
    Create a new OAuth-like consent request.
    
    This endpoint is typically called by third-party applications
    that want to request access to a developer's data.
    
    Args:
        request: Consent request details
        current_developer: The developer who needs to grant consent
        
    Returns:
        Created consent request details
    """
    # Generate unique consent request ID
    consent_id = str(uuid.uuid4())
    
    # Calculate expiration time
    expires_at = datetime.now(timezone.utc) + timedelta(minutes=request.expires_minutes)
    
    # Create consent request
    consent_request = ConsentRequest(
        id=consent_id,
        client_id=request.client_id,
        client_name=request.client_name,
        client_description=request.client_description,
        client_logo_url=request.client_logo_url,
        developer_id=current_developer.id,
        scopes=request.scopes,
        redirect_uri=request.redirect_uri,
        state=request.state,
        expires_at=expires_at
    )
    
    # Store in Firestore
    await firestore_service.create_consent_request(consent_request)
    
    return ConsentRequestResponse(
        id=consent_request.id,
        client_id=consent_request.client_id,
        client_name=consent_request.client_name,
        client_description=consent_request.client_description,
        client_logo_url=consent_request.client_logo_url,
        scopes=consent_request.scopes,
        redirect_uri=consent_request.redirect_uri,
        state=consent_request.state,
        status=consent_request.status,
        created_at=consent_request.created_at,
        expires_at=consent_request.expires_at
    )


@router.get("/authorize/{consent_id}", response_class=HTMLResponse)
async def show_consent_page(
    consent_id: str,
    current_developer: Developer = Depends(get_current_developer)
):
    """
    Show the consent authorization page.
    
    This endpoint displays a consent page where the developer
    can review and approve/deny the requested permissions.
    
    Args:
        consent_id: The consent request ID
        current_developer: The authenticated developer
        
    Returns:
        HTML consent page
    """
    # Get consent request
    consent_request = await firestore_service.get_consent_request(consent_id)
    if not consent_request:
        raise HTTPException(status_code=404, detail="Consent request not found")
    
    # Verify the developer owns this consent request
    if consent_request.developer_id != current_developer.id:
        raise HTTPException(status_code=403, detail="Not authorized to view this consent request")
    
    # Check if request is still valid
    if consent_request.expires_at < datetime.now(timezone.utc):
        raise HTTPException(status_code=410, detail="Consent request has expired")
    
    if consent_request.status != ConsentStatus.PENDING:
        raise HTTPException(status_code=400, detail="Consent request is no longer pending")
    
    # Generate HTML consent page
    scope_descriptions = {
        ConsentScope.READ_TASKS: "Read your tasks and project data",
        ConsentScope.WRITE_TASKS: "Create and modify your tasks",
        ConsentScope.DELETE_TASKS: "Delete your tasks",
        ConsentScope.READ_PROFILE: "Read your profile information",
        ConsentScope.WRITE_PROFILE: "Update your profile information"
    }
    
    scopes_html = ""
    for scope in consent_request.scopes:
        description = scope_descriptions.get(scope, str(scope))
        scopes_html += f"<li><strong>{scope}</strong>: {description}</li>"
    
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Authorize Application - CheckList API</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }}
            .container {{ max-width: 500px; margin: 0 auto; background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
            .app-info {{ text-align: center; margin-bottom: 30px; }}
            .app-logo {{ width: 64px; height: 64px; border-radius: 8px; margin-bottom: 15px; }}
            .app-name {{ font-size: 24px; font-weight: 600; margin-bottom: 10px; color: #333; }}
            .app-description {{ color: #666; margin-bottom: 20px; }}
            .scopes {{ background: #f8f9fa; border-radius: 6px; padding: 20px; margin-bottom: 30px; }}
            .scopes h3 {{ margin-top: 0; color: #333; }}
            .scopes ul {{ margin: 0; padding-left: 20px; }}
            .scopes li {{ margin-bottom: 8px; color: #555; }}
            .actions {{ display: flex; gap: 15px; }}
            .btn {{ flex: 1; padding: 12px 20px; border: none; border-radius: 6px; font-size: 16px; font-weight: 500; cursor: pointer; }}
            .btn-approve {{ background: #007bff; color: white; }}
            .btn-deny {{ background: #6c757d; color: white; }}
            .btn:hover {{ opacity: 0.9; }}
            .developer-info {{ background: #e3f2fd; padding: 15px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; color: #1565c0; }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="app-info">
                {f'<img src="{consent_request.client_logo_url}" alt="App Logo" class="app-logo">' if consent_request.client_logo_url else ''}
                <div class="app-name">{consent_request.client_name}</div>
                {f'<div class="app-description">{consent_request.client_description}</div>' if consent_request.client_description else ''}
            </div>
            
            <div class="developer-info">
                <strong>Logged in as:</strong> {current_developer.full_name} ({current_developer.email})
            </div>
            
            <div class="scopes">
                <h3>This application is requesting permission to:</h3>
                <ul>
                    {scopes_html}
                </ul>
            </div>
            
            <div class="actions">
                <form method="post" action="/api/v1/consent/respond" style="flex: 1;">
                    <input type="hidden" name="consent_id" value="{consent_id}">
                    <input type="hidden" name="granted" value="false">
                    <button type="submit" class="btn btn-deny">Deny</button>
                </form>
                <form method="post" action="/api/v1/consent/respond" style="flex: 1;">
                    <input type="hidden" name="consent_id" value="{consent_id}">
                    <input type="hidden" name="granted" value="true">
                    <button type="submit" class="btn btn-approve">Authorize</button>
                </form>
            </div>
        </div>
    </body>
    </html>
    """
    
    return HTMLResponse(content=html_content)


@router.post("/respond")
async def handle_consent_response(
    consent_id: str = Form(...),
    granted: bool = Form(...),
    current_developer: Developer = Depends(get_current_developer)
):
    """
    Handle the developer's response to a consent request.
    
    Args:
        consent_id: The consent request ID
        granted: Whether consent was granted
        current_developer: The authenticated developer
        
    Returns:
        Redirect to the client application
    """
    # Get consent request
    consent_request = await firestore_service.get_consent_request(consent_id)
    if not consent_request:
        raise HTTPException(status_code=404, detail="Consent request not found")
    
    # Verify ownership
    if consent_request.developer_id != current_developer.id:
        raise HTTPException(status_code=403, detail="Not authorized")
    
    # Update consent status
    if granted:
        consent_request.status = ConsentStatus.GRANTED
        consent_request.granted_at = datetime.now(timezone.utc)
        consent_request.granted_scopes = consent_request.scopes
        
        # Create persistent consent grant
        grant = ConsentGrant(
            id=str(uuid.uuid4()),
            developer_id=current_developer.id,
            client_id=consent_request.client_id,
            client_name=consent_request.client_name,
            scopes=consent_request.scopes,
            granted_at=datetime.now(timezone.utc)
        )
        await firestore_service.create_consent_grant(grant)
        
    else:
        consent_request.status = ConsentStatus.DENIED
    
    # Update consent request
    await firestore_service.update_consent_request(consent_request)
    
    # Build redirect URL
    redirect_url = consent_request.redirect_uri
    if "?" in redirect_url:
        redirect_url += "&"
    else:
        redirect_url += "?"
    
    redirect_url += f"consent_id={consent_id}&status={consent_request.status.value}"
    if consent_request.state:
        redirect_url += f"&state={consent_request.state}"
    
    return RedirectResponse(url=redirect_url, status_code=302)


@router.get("/grants", response_model=ConsentGrantListResponse)
async def list_consent_grants(
    current_developer: Developer = Depends(get_current_developer)
):
    """
    List all active consent grants for the current developer.
    
    Args:
        current_developer: The authenticated developer
        
    Returns:
        List of active consent grants
    """
    grants = await firestore_service.get_developer_consent_grants(current_developer.id)
    
    grant_responses = [
        ConsentGrantResponse(
            id=grant.id,
            client_id=grant.client_id,
            client_name=grant.client_name,
            scopes=grant.scopes,
            granted_at=grant.granted_at,
            last_used=grant.last_used,
            is_active=grant.is_active
        )
        for grant in grants
        if grant.is_active
    ]
    
    return ConsentGrantListResponse(
        grants=grant_responses,
        total=len(grant_responses)
    )


@router.delete("/grants/{grant_id}")
async def revoke_consent_grant(
    grant_id: str,
    current_developer: Developer = Depends(get_current_developer)
):
    """
    Revoke a consent grant.
    
    Args:
        grant_id: The consent grant ID to revoke
        current_developer: The authenticated developer
        
    Returns:
        Success message
    """
    # Get the grant
    grant = await firestore_service.get_consent_grant(grant_id)
    if not grant:
        raise HTTPException(status_code=404, detail="Consent grant not found")
    
    # Verify ownership
    if grant.developer_id != current_developer.id:
        raise HTTPException(status_code=403, detail="Not authorized to revoke this grant")
    
    # Revoke the grant
    grant.is_active = False
    await firestore_service.update_consent_grant(grant)
    
    return {"message": "Consent grant revoked successfully"}


@router.get("/requests/{consent_id}", response_model=ConsentRequestResponse)
async def get_consent_request(
    consent_id: str,
    current_developer: Developer = Depends(get_current_developer)
):
    """
    Get details of a specific consent request.
    
    Args:
        consent_id: The consent request ID
        current_developer: The authenticated developer
        
    Returns:
        Consent request details
    """
    consent_request = await firestore_service.get_consent_request(consent_id)
    if not consent_request:
        raise HTTPException(status_code=404, detail="Consent request not found")
    
    # Verify ownership
    if consent_request.developer_id != current_developer.id:
        raise HTTPException(status_code=403, detail="Not authorized to view this consent request")
    
    return ConsentRequestResponse(
        id=consent_request.id,
        client_id=consent_request.client_id,
        client_name=consent_request.client_name,
        client_description=consent_request.client_description,
        client_logo_url=consent_request.client_logo_url,
        scopes=consent_request.scopes,
        redirect_uri=consent_request.redirect_uri,
        state=consent_request.state,
        status=consent_request.status,
        created_at=consent_request.created_at,
        expires_at=consent_request.expires_at
    )