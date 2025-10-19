# CheckList API - Developer Platform

A comprehensive REST API for the CheckList application with a complete developer platform featuring OAuth authentication, API key management, usage analytics, and automated documentation.

## 🌟 Features

### Developer Platform
- **Multi-Auth Support**: Email/password and Google OAuth authentication
- **Email Verification**: OTP-based email verification with beautiful HTML emails
- **API Key Management**: Create, manage, and monitor API keys with granular scopes
- **Usage Analytics**: Comprehensive tracking of API usage, success rates, and performance
- **Rate Limiting**: Configurable rate limits per API key
- **Developer Portal**: Web interface for managing API keys and viewing analytics

### Security & Performance
- **JWT Authentication**: Secure token-based authentication for developers
- **API Key Authentication**: Industry-standard API key authentication for third-party apps
- **Rate Limiting**: Protect against abuse with configurable limits
- **CORS Support**: Cross-origin resource sharing for web applications
- **Request Logging**: Detailed logging of all API requests and responses

### Infrastructure
- **FastAPI Framework**: High-performance async API with auto-generated documentation
- **Firestore Integration**: Scalable NoSQL database for all data storage
- **Email Service**: Automated email delivery via SendGrid
- **Production Ready**: Comprehensive error handling, logging, and monitoring

### Core API Features
- **Task Management**: Complete CRUD operations with hierarchical tasks and subtasks
- **File Attachments**: Upload files, images, voice memos, and links to tasks
- **Rich Content**: Image processing, thumbnail generation, and metadata extraction
- **Search & Analytics**: Advanced filtering and statistics across all content

## 🏗️ Architecture

```
CheckList API Developer Platform
├── Authentication Service
│   ├── Email/Password Registration
│   ├── Google OAuth Integration
│   ├── Email Verification (OTP)
│   └── JWT Token Management
├── API Key Management
│   ├── Key Generation & Hashing
│   ├── Scope-based Permissions
│   ├── Usage Tracking
│   └── Rate Limiting
├── Analytics & Monitoring
│   ├── Request Logging
│   ├── Usage Analytics
│   ├── Performance Metrics
│   └── Developer Dashboard
└── Core API
    ├── Task Management
    ├── File Attachments
    ├── User Management
    └── Developer Resources
```

## � Quick Start

### Prerequisites

- Python 3.11+
- Google Cloud Project (for Firestore)
- SendGrid Account (for email delivery)
- Poetry (for dependency management)

### Installation

1. **Clone and Navigate**
   ```bash
   cd api_server
   ```

2. **Install Dependencies**
   ```bash
   poetry install
   ```

3. **Environment Configuration**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Google Cloud Setup**
   ```bash
   # Set up Application Default Credentials
   gcloud auth application-default login
   
   # Or use service account key
   export GOOGLE_APPLICATION_CREDENTIALS="path/to/service-account-key.json"
   ```

5. **Run the Server**
   ```bash
   poetry run python -m app.main
   ```

The API will be available at `http://localhost:8000` with interactive documentation at `http://localhost:8000/docs`.

## 🔧 Configuration

### Environment Variables

```bash
# API Configuration
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=false
SECRET_KEY=your-secret-key-here

# Google Cloud / Firestore
GOOGLE_CLOUD_PROJECT=your-project-id
GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json

# Google OAuth
GOOGLE_OAUTH_CLIENT_ID=your-oauth-client-id
GOOGLE_OAUTH_CLIENT_SECRET=your-oauth-client-secret
GOOGLE_OAUTH_REDIRECT_URI=http://localhost:8000/api/v1/auth/google/callback

# Email Configuration
EMAIL_PROVIDER=sendgrid
SENDGRID_API_KEY=your-sendgrid-api-key
FROM_EMAIL=noreply@checklist-api.com
FROM_NAME=CheckList API

# API Key Settings
API_KEY_DEFAULT_RATE_LIMIT=1000
OTP_EXPIRE_MINUTES=10
```

### Google Cloud Setup

1. **Create a Google Cloud Project**
2. **Enable Firestore**
   ```bash
   gcloud services enable firestore.googleapis.com
   ```
3. **Create OAuth 2.0 Credentials**
   - Go to Google Cloud Console > APIs & Credentials
   - Create OAuth 2.0 Client ID for web application
   - Add authorized redirect URIs

4. **Set up Service Account** (optional)
   ```bash
   gcloud iam service-accounts create checklist-api
   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:checklist-api@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/datastore.user"
   ```

## 📋 API Reference

### Authentication Endpoints

#### Register Developer
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "developer@example.com",
  "password": "secure_password",
  "name": "John Developer",
  "company": "Acme Corp",
  "website": "https://acme.com"
}
```

#### Verify Email
```http
POST /api/v1/auth/verify-email
Content-Type: application/json

{
  "email": "developer@example.com",
  "otp": "123456"
}
```

#### Google OAuth Login
```http
GET /api/v1/auth/google/login?redirect_url=https://your-app.com/dashboard
```

#### Login with Email
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "developer@example.com",
  "password": "secure_password"
}
```

### API Key Management

#### Create API Key
```http
POST /api/v1/api-keys
Authorization: Bearer {jwt_token}
Content-Type: application/json

{
  "name": "Production API Key",
  "scopes": ["read", "write"],
  "rate_limit_per_hour": 1000,
  "expires_days": 365
}
```

#### List API Keys
```http
GET /api/v1/api-keys
Authorization: Bearer {jwt_token}
```

#### Get Analytics
```http
GET /api/v1/api-keys/analytics/summary
Authorization: Bearer {jwt_token}
```

#### Get Usage Logs
```http
GET /api/v1/api-keys/usage/logs?limit=100
Authorization: Bearer {jwt_token}
```

### Using API Keys

For third-party applications, use API keys in the `X-API-Key` header:

```http
GET /api/v1/tasks
X-API-Key: cla_dev123456789abcdef1234567890abcdef
```

## 🔐 Authentication Flow

### For Developers (Managing API Keys)

1. **Register** → Email verification → **Login** → Get JWT token
2. Use JWT token to manage API keys and view analytics
3. Alternative: Use Google OAuth for quick registration/login

### For Third-party Apps (Using the API)

1. Developer creates API key in the developer portal
2. Third-party app uses API key in requests
3. All requests are logged and counted against rate limits

## 📊 Developer Portal Features

### API Key Management
- Create multiple API keys with different scopes
- View usage statistics for each key
- Deactivate or delete keys
- Configure rate limits per key

### Analytics Dashboard
- Total requests and success rates
- Usage trends over time
- Error rate monitoring
- Performance metrics

### Usage Monitoring
- Real-time request logs
- Detailed error information
- Geographic usage distribution
- API endpoint popularity

## 🛠️ Development

### Project Structure

```
api_server/
├── app/
│   ├── config.py              # Configuration settings
│   ├── main.py               # FastAPI application
│   ├── dependencies/
│   │   └── auth.py           # Authentication dependencies
│   ├── models/
│   │   └── developer.py      # Pydantic models
│   ├── routers/
│   │   ├── auth.py          # Authentication endpoints
│   │   ├── api_keys.py      # API key management
│   │   ├── tasks.py         # Task management
│   │   └── users.py         # User management
│   ├── services/
│   │   ├── email_service.py      # Email delivery
│   │   ├── firestore_service.py  # Database operations
│   │   └── google_oauth_service.py # OAuth integration
│   └── utils/
│       └── security.py      # Security utilities
├── tests/                   # Test files
├── demo.py                 # API demonstration
├── pyproject.toml          # Dependencies
└── .env.example           # Environment template
```

### Running Tests

```bash
poetry run pytest
```

### API Documentation

- **Swagger UI**: `http://localhost:8000/docs`
- **ReDoc**: `http://localhost:8000/redoc`
- **OpenAPI JSON**: `http://localhost:8000/openapi.json`

### Demonstration

Run the included demo script to see the complete API flow:

```bash
poetry run python demo.py
```

## 🔍 Monitoring & Logging

### Health Checks

```http
GET /health
GET /api/v1/auth/health
```

### Structured Logging

All requests are logged with structured data including:
- Request/response details
- Performance metrics
- Error information
- User context

### Error Handling

- Comprehensive error responses
- Rate limiting with clear messages
- Authentication error details
- Input validation errors

## 🚢 Deployment

### Docker Deployment

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN pip install poetry && poetry install --no-dev

COPY app ./app
CMD ["poetry", "run", "python", "-m", "app.main"]
```

### Environment Variables for Production

```bash
DEBUG=false
API_WORKERS=4
ENVIRONMENT=production
ALLOWED_ORIGINS=https://yourdomain.com,https://api.yourdomain.com
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## 📝 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the GitHub repository
- Check the API documentation at `/docs`
- Review the demo script for usage examples

---

**CheckList API** - Empowering developers with a complete task management platform 🚀

## 🏃‍♂️ Running the Server

### Development Mode
```bash
# Using Poetry script
poetry run dev

# Or directly with uvicorn
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Production Mode
```bash
poetry run start
```

## 📚 API Documentation

Once the server is running, visit:
- **Interactive Docs**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc
- **Health Check**: http://localhost:8000/health

## 🔐 Authentication

The API uses JWT-based authentication. Include the token in requests:

```bash
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" http://localhost:8000/api/v1/tasks
```

## 📋 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/refresh` - Refresh JWT token

### Tasks
- `GET /api/v1/tasks` - List tasks (with filtering, pagination)
- `POST /api/v1/tasks` - Create new task
- `GET /api/v1/tasks/{task_id}` - Get specific task
- `PUT /api/v1/tasks/{task_id}` - Update task
- `PATCH /api/v1/tasks/{task_id}` - Partial update
- `DELETE /api/v1/tasks/{task_id}` - Delete task

### Users
- `GET /api/v1/users/me` - Get current user profile
- `PUT /api/v1/users/me` - Update user profile

## 🧪 Testing

```bash
# Run all tests
poetry run pytest

# Run with coverage
poetry run pytest --cov=app

# Run specific test file
poetry run pytest tests/test_tasks.py
```

## 🔧 Development Tools

```bash
# Code formatting
poetry run black .

# Import sorting
poetry run isort .

# Linting
poetry run flake8

# Type checking
poetry run mypy app/
```

## 📁 Project Structure

```
api_server/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI application
│   ├── config.py            # Configuration settings
│   ├── database/
│   │   ├── __init__.py
│   │   └── firestore.py     # Firestore client
│   ├── models/
│   │   ├── __init__.py
│   │   ├── task.py          # Task Pydantic models
│   │   ├── user.py          # User Pydantic models
│   │   └── auth.py          # Auth Pydantic models
│   ├── routers/
│   │   ├── __init__.py
│   │   ├── auth.py          # Authentication routes
│   │   ├── tasks.py         # Task management routes
│   │   └── users.py         # User management routes
│   ├── services/
│   │   ├── __init__.py
│   │   ├── auth.py          # Authentication service
│   │   ├── task.py          # Task service
│   │   └── user.py          # User service
│   └── utils/
│       ├── __init__.py
│       ├── security.py      # JWT and password utilities
│       └── logging.py       # Logging configuration
├── tests/
├── .env.example
├── environment.yml
├── pyproject.toml
└── README.md
```

## 🚀 Deployment

### Docker
```bash
# Build image
docker build -t checklist-api .

# Run container
docker run -p 8000:8000 checklist-api
```

### Google Cloud Run
```bash
# Deploy to Cloud Run
gcloud run deploy checklist-api --source . --platform managed
```

## 📄 License

This project is licensed under the MIT License.
