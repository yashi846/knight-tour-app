@echo off
echo ナイト・ツアーAPI セットアップ中...

echo.
echo Step 1: pip、setuptools、wheelをアップグレード
pip install --upgrade pip setuptools wheel

echo.
echo Step 2: 依存関係をインストール
pip install -r requirements.txt

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo requirements.txtでエラーが発生しました。個別にインストールを試行します...
    pip install "Flask>=2.3.2"
    pip install "Flask-CORS>=4.0.0"
    pip install "numpy>=1.26.0"
    pip install "amplify>=0.12.0"
    pip install "requests>=2.31.0"
)

echo.
echo セットアップが完了しました！
echo サーバーを起動するには以下のコマンドを実行してください：
echo python app.py
echo.
pause
