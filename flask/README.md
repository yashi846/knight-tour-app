# ナイト・ツアー問題 Flask API

このAPIは、チェスのナイト（騎士）の駒を使った「ナイト・ツアー問題」の解決可能性を判定するためのREST APIです。

## 機能

- 既に訪問済みの手順を受け取り、残りの手順でナイト・ツアーが完成可能かを判定
- 非同期処理による応答性の向上
- エラーハンドリングとタイムアウト処理
- CORS対応

## API仕様

### エンドポイント

#### POST /check_knight_tour

ナイト・ツアーの解決可能性をチェックします。

**リクエスト**

```json
{
  "board_size": 8,
  "current_position": { "x": 2, "y": 4 },
  "visited_squares": [
    { "x": 0, "y": 0 },
    { "x": 1, "y": 2 },
    { "x": 2, "y": 4 }
  ]
}
```

**パラメータ**
- `board_size`: 盤面のサイズ（5-10の整数）
- `current_position`: 現在の位置（x, y座標）
- `visited_squares`: 訪問済みの座標の配列

**レスポンス**

成功時（200 OK）:
```json
{ "status": "solvable" }
```
または
```json
{ "status": "unsolvable" }
```

エラー時（400 Bad Request, 408 Request Timeout, 500 Internal Server Error）:
```json
{ "error": "エラーメッセージ" }
```

#### GET /health

ヘルスチェック用エンドポイントです。

**レスポンス**
```json
{ "status": "healthy" }
```

## セットアップ

### 前提条件

- Python 3.8以上（Python 3.12推奨）
- pip（Pythonパッケージマネージャー）

### 1. 依存関係のインストール

```bash
pip install -r requirements.txt
```

**Python 3.12をお使いの場合の注意点:**
古いバージョンのnumpyでエラーが発生する場合は、以下を試してください：

```bash
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
```

### 2. サーバーの起動

```bash
python app.py
```

サーバーは `http://localhost:5000` で起動します。

### 3. テストの実行

```bash
python test_api.py
```

## 使用例

### Python (requests)

```python
import requests

url = "http://localhost:5000/check_knight_tour"
data = {
    "board_size": 8,
    "current_position": {"x": 2, "y": 4},
    "visited_squares": [
        {"x": 0, "y": 0},
        {"x": 1, "y": 2},
        {"x": 2, "y": 4}
    ]
}

response = requests.post(url, json=data)
print(response.json())
```

### JavaScript (fetch)

```javascript
const response = await fetch('http://localhost:5000/check_knight_tour', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        board_size: 8,
        current_position: { x: 2, y: 4 },
        visited_squares: [
            { x: 0, y: 0 },
            { x: 1, y: 2 },
            { x: 2, y: 4 }
        ]
    })
});

const result = await response.json();
console.log(result);
```

## エラーハンドリング

APIは以下のエラーを適切に処理します：

- **400 Bad Request**: 不正なリクエストデータ
- **408 Request Timeout**: 処理時間が長すぎる場合
- **500 Internal Server Error**: サーバー内部エラー

## 技術仕様

- **フレームワーク**: Flask
- **最適化エンジン**: Amplify (Fixstars)
- **処理方式**: 非同期処理（ThreadPoolExecutor）
- **タイムアウト**: 45秒
- **CORS**: 有効化済み

## 制限事項

- 盤面サイズは5x5から10x10まで
- 処理時間は最大45秒
- 1リクエストあたりの最大処理時間制限あり
- Python 3.8以上が必要

## トラブルシューティング

### numpy インストールエラー

Python 3.12で以下のエラーが発生する場合：
```
AttributeError: module 'pkgutil' has no attribute 'ImpImporter'
```

**解決方法:**
```bash
pip install --upgrade pip setuptools wheel
pip install numpy>=1.26.0
pip install -r requirements.txt
```

### Amplifyトークンエラー

Amplifyのトークンが無効な場合は、`app.py`の以下の行を更新してください：
```python
client.token = "YOUR_AMPLIFY_TOKEN_HERE"
```

### ポート使用エラー

ポート5000が既に使用されている場合は、`app.py`の最後の行を変更してください：
```python
app.run(debug=True, host='0.0.0.0', port=5001)  # ポート番号を変更
```

## 開発者向け情報

### ログ設定

アプリケーションはINFOレベルでログを出力します。主な情報：
- リクエストの受信
- 処理の開始と完了
- エラーの詳細

### カスタマイズ

- `client.token`: Amplify APIトークンの設定
- `client.parameters.timeout`: 最適化エンジンのタイムアウト設定
- `future.result(timeout=45)`: API全体のタイムアウト設定
