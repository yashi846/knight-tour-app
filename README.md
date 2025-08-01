# ナイトツアーパズル

チェスのナイト（騎士）が8×8のチェス盤上で各マスを一度ずつ訪問する古典的なパズルゲームです。

## 概要

ナイトツアーは、チェス盤上のナイトを使った数学的問題です。ナイトはチェスのルール通りに移動し、すべてのマスを一度ずつ訪問する必要があります。

## デモ動画

https://github.com/user-attachments/assets/0eb9058f-afa3-452a-91f6-c52b1d782f69

## 機能

- インタラクティブなチェス盤インターフェース
- 移動可能な位置の視覚的ハイライト
- 手数カウンターと進行状況の追跡
- 移動とゲーム完了時の音声フィードバック
- 量子アニーリング統合による高度な解析（開発モードのみ）

## システム要件

- Flutter SDK 3.24.3以降
- Python 3.8以降  
- モダンブラウザ

## インストールと実行

#### 前提条件
```bash
# リポジトリをクローン
git clone https://github.com/yashi846/knight-tour-app.git
cd knight-tour-app
```

#### 標準実行
```bash
# Flask APIサーバーのセットアップ
cd flask
python -m venv venv
venv\Scripts\activate  # Windows
# source venv/bin/activate  # macOS/Linux
pip install flask flask-cors amplify numpy
python app.py

# 新しいターミナルでFlutterアプリケーションをセットアップ
cd ..
flutter pub get
flutter run
```

## 使用方法

1. 「ゲーム開始」をクリックして開始
2. 任意のマスをクリックしてナイトを配置
3. ハイライトされたマスをクリックしてナイトを移動
4. 全64マスを訪問してパズルを完成
5. いつでも「リセット」で最初からやり直し可能

## 技術アーキテクチャ

### 主要コンポーネント
- **Flutterアプリケーション**: クロスプラットフォームUIフレームワーク
- **Pythonランチャー**: スタンドアロン実行用シンプルHTTPサーバー
- **Flask API**: オプションの量子アニーリング統合
- **Webアセット**: ゲームグラフィックスと音声リソース

### プロジェクト構造
```
knight-tour-app/
├── lib/                    # Flutterアプリケーションソース
├── web/                    # Webプラットフォーム設定
├── flask/                  # Flask APIサーバー（量子機能）
├── assets/                 # ゲームアセット（画像、音声）
├── simple_launcher.py      # Python Webサーバーランチャー
└── README.md              # このドキュメント
```

### APIエンドポイント（開発モード）

#### `GET /health`
サーバーステータス情報を返します。

#### `POST /check_knight_tour`
量子アニーリングアルゴリズムを使用して現在の盤面状態を解析します。

**リクエスト形式:**
```json
{
  "board_size": 8,
  "current_position": {"x": 2, "y": 4},
  "visited_squares": [{"x": 0, "y": 0}, {"x": 1, "y": 2}],
  "amplify_token": "AE/your-token-here"
}
```


