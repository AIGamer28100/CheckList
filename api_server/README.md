# CheckList API Server

A high-performance RESTful API server for the CheckList todo application built with FastAPI, Pydantic, and Google Firestore.

## 🚀 Features

- **FastAPI**: High-performance async web framework
- **Pydantic**: Data validation and serialization
- **Firestore**: Cloud-native NoSQL database
- **JWT Authentication**: Secure user authentication
- **Auto Documentation**: Interactive API docs with Swagger/OpenAPI
- **CORS Support**: Cross-origin resource sharing
- **Structured Logging**: Comprehensive request/response logging
- **Type Safety**: Full TypeScript-like type annotations

## 🛠️ Setup

### Prerequisites

- Python 3.11+
- Conda (for environment management)
- Poetry (for dependency management)
- Google Cloud Project with Firestore enabled

### Environment Setup

1. **Create Conda Environment**:
   ```bash
   conda env create -f environment.yml
   conda activate checklist-api
   ```

2. **Install Dependencies with Poetry**:
   ```bash
   poetry install
   ```

3. **Configure Environment Variables**:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Set up Google Cloud Credentials**:
   ```bash
   # Place your service account key file in the project
   export GOOGLE_APPLICATION_CREDENTIALS="path/to/service-account-key.json"
   ```

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
