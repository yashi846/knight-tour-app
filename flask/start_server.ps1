# PowerShell script to start the Knight Tour API server

Write-Host "ナイト・ツアーAPI サーバーを起動中..." -ForegroundColor Green

# Python バージョンチェック
$pythonVersion = python --version 2>&1
Write-Host "Python バージョン: $pythonVersion" -ForegroundColor Cyan

# 仮想環境が存在するかチェック
if (Test-Path "venv") {
    Write-Host "仮想環境を有効化中..." -ForegroundColor Yellow
    & "venv\Scripts\Activate.ps1"
} else {
    Write-Host "仮想環境を作成中..." -ForegroundColor Yellow
    python -m venv venv
    & "venv\Scripts\Activate.ps1"
}

# pipとsetuptoolsをアップグレード
Write-Host "pip、setuptools、wheelをアップグレード中..." -ForegroundColor Yellow
pip install --upgrade pip setuptools wheel

# 依存関係のインストール
Write-Host "依存関係をインストール中..." -ForegroundColor Yellow
pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "依存関係のインストールに失敗しました。個別にインストールを試行します..." -ForegroundColor Red
    pip install "Flask>=2.3.2"
    pip install "Flask-CORS>=4.0.0"
    pip install "numpy>=1.26.0"
    pip install "amplify>=0.12.0"
    pip install "requests>=2.31.0"
}

# サーバーの起動
Write-Host "サーバーを起動中..." -ForegroundColor Green
Write-Host "サーバーは http://localhost:5000 で起動します" -ForegroundColor Cyan
Write-Host "終了するには Ctrl+C を押してください" -ForegroundColor Cyan

python app.py
