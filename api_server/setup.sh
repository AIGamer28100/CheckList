#!/bin/bash

# CheckList API Server Setup Script
# This script sets up the development environment for the FastAPI server

set -e  # Exit on any error

echo "🚀 Setting up CheckList API Server environment..."

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "❌ Conda is not installed. Please install Miniconda or Anaconda first."
    echo "Download from: https://docs.conda.io/en/latest/miniconda.html"
    exit 1
fi

# Navigate to API server directory
cd "$(dirname "$0")"

echo "📁 Current directory: $(pwd)"

# Create conda environment
echo "🔧 Creating conda environment 'checklist-api'..."
if conda env list | grep -q "checklist-api"; then
    echo "⚠️  Environment 'checklist-api' already exists. Removing and recreating..."
    conda env remove -n checklist-api -y
fi

conda env create -f environment.yml

echo "🔄 Activating conda environment..."
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate checklist-api

# Verify poetry is available
echo "🔍 Checking Poetry installation..."
if ! command -v poetry &> /dev/null; then
    echo "❌ Poetry not found in conda environment. Installing..."
    conda install -c conda-forge poetry -y
fi

# Configure poetry to create virtual environment in project directory
echo "⚙️  Configuring Poetry..."
poetry config virtualenvs.create true
poetry config virtualenvs.in-project true

# Install dependencies
echo "📦 Installing Python dependencies with Poetry..."
poetry install

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📄 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your configuration before running the server!"
fi

echo "✅ Setup complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Activate the conda environment: conda activate checklist-api"
echo "2. Edit the .env file with your configuration"
echo "3. Set up Google Cloud credentials (service account key)"
echo "4. Run the development server: poetry run dev"
echo ""
echo "📚 Available commands:"
echo "  poetry run dev     - Start development server with hot reload"
echo "  poetry run start   - Start production server"
echo "  poetry run pytest  - Run tests"
echo "  poetry run black . - Format code"
echo "  poetry run mypy app/ - Type checking"
echo ""
echo "📖 Documentation will be available at: http://localhost:8000/docs"