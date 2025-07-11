# Flask API と Flutter アプリの連携ガイド

## 設定完了項目

### 1. Flask API サーバー設定
- ✅ CORS設定を追加（全オリジン許可）
- ✅ `/check_knight_tour` エンドポイントが利用可能
- ✅ `/health` ヘルスチェックエンドポイントが利用可能

### 2. Flutter アプリ設定
- ✅ API URL を `http://localhost:5000/check_knight_tour` に設定
- ✅ Android ManifestにINTERNET権限とHTTP通信許可を追加
- ✅ 既存のゲームロジックは変更せず、API通信部分のみ修正

## 動作確認手順

### 1. Flask サーバーの起動
```powershell
# PowerShellでflaskフォルダに移動
cd C:\Flutter\flask

# 依存関係のインストール
pip install -r requirements.txt

# サーバー起動
python app.py
```

または、提供されているスクリプトを使用：
```powershell
.\start_server.ps1
```

### 2. 接続テスト
```powershell
# 接続テストスクリプトを実行
python test_connection.py
```

### 3. Flutter アプリの実行
```powershell
# myappフォルダに移動
cd C:\Flutter\myapp

# Flutter アプリを実行
flutter run
```

## 利用方法

1. **Flaskサーバー起動**: `python app.py` でサーバーを起動
2. **Flutterアプリ起動**: `flutter run` でアプリを起動
3. **ゲームプレイ**: チェス盤にナイトを配置して移動
4. **API呼び出し**: 「ゲームオーバーチェック」ボタンを押すとFlask APIが呼び出される

## API仕様

### エンドポイント
- `POST /check_knight_tour` - ナイトツアーの継続可能性をチェック
- `GET /health` - サーバーの状態確認

### リクエスト形式
```json
{
  "board_size": 8,
  "current_position": {"x": 0, "y": 0},
  "visited_squares": [
    {"x": 0, "y": 0}
  ]
}
```

### レスポンス形式
```json
{
  "status": "solvable"  // または "unsolvable"
}
```

## トラブルシューティング

### よくある問題と解決方法

1. **CORS エラー**
   - Flask サーバーのCORS設定を確認
   - ブラウザのデベロッパーツールでエラーを確認

2. **接続エラー**
   - Flask サーバーが起動しているか確認
   - URLが正しいか確認 (`http://localhost:5000`)
   - ファイアウォールの設定を確認

3. **タイムアウト**
   - 大きな盤面や複雑な状況では処理時間が長くなる可能性
   - タイムアウト設定を調整

4. **依存関係エラー**
   - `pip install -r requirements.txt` で依存関係を再インストール
   - Amplifyライブラリのトークンが正しいか確認

## 注意事項

- Flask サーバーはローカル環境での開発用設定です
- 本番環境では適切なセキュリティ設定を行ってください
- Amplifyのトークンは本番環境では環境変数として管理してください
