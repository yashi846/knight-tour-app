# PowerShell script to start the Knight Tour API server

Write-Host "Knight Tour API Server Starting..." -ForegroundColor Green

# Python version check
$pythonVersion = python --version 2>&1
Write-Host "Python Version: $pythonVersion" -ForegroundColor Cyan

# Virtual environment check
if (Test-Path "venv") {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & "venv\Scripts\Activate.ps1"
} else {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
    & "venv\Scripts\Activate.ps1"
}

# Upgrade pip and setuptools
Write-Host "Upgrading pip, setuptools, wheel..." -ForegroundColor Yellow
pip install --upgrade pip setuptools wheel

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to install dependencies. Trying individual installation..." -ForegroundColor Red
    pip install "Flask>=2.3.2"
    pip install "Flask-CORS>=4.0.0"
    pip install "numpy>=1.26.0"
    pip install "amplify>=0.12.0"
    pip install "requests>=2.31.0"
}

# Start server
Write-Host "Starting server..." -ForegroundColor Green
Write-Host "Server will start at http://localhost:5000" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Cyan

python app.py
