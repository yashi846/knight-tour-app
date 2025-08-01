# ナイトツアーパズル - Knight Tour Puzzle

チェスのナイト（騎士）を使った古典的なパズルゲームです。8×8のチェス盤で、ナイトが各マスを一度ずつ訪問し、全64マスを制覇することが目標です。量子アニーリング機能により、行き詰まった際に解決可能かどうかを判定できます。

🌐 **[いますぐブラウザでプレイ！](https://yashi846.github.io/knight-tour-app/)** 🎮

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-327FC7?style=for-the-badge&logo=github&logoColor=white)

## 🎮 ゲーム機能

- **直感的な操作**: タップでナイトを配置・移動
- **視覚的なヒント**: 移動可能なマスを緑色でハイライト
- **進行状況表示**: 手数カウンターと訪問済みマスの番号表示
- **量子アニーリング**: Fixstars Amplifyによる解決可能性判定
- **音響効果**: 駒の移動音と勝利・敗北BGM
- **マルチプラットフォーム**: Web、Windows、Android、iOS対応

## 🚀 実行方法

### 1. Web版（推奨・最も簡単）

**インストール不要で即プレイ！**

🌐 **[ナイトツアーパズルをプレイ](https://yashi846.github.io/knight-tour-app/)**

- ✅ ブラウザだけでプレイ可能
- ✅ Flutter・Python不要
- ✅ すべてのデバイス対応（PC・スマホ・タブレット）
- ✅ 最新版が自動配信

### 2. シンプル実行（Python環境がある場合）

```cmd
python simple_launcher.py
```
- ✅ 確実に動作
- ✅ ブラウザ自動起動
- ✅ Web版のみ（量子機能なし）

### 3. EXEファイル実行（Windows専用）

**注意**: 現在、古いEXEファイルがWindows Defenderによって保護されているため、手動で削除する必要があります。

既存のEXEファイル:
```cmd
KnightTourPuzzle.exe
```

**特徴:**
- ✅ Pythonインストール不要
- ✅ ワンクリックで起動
- ✅ スタンドアロン実行
- ⚠️ Windows Defenderで警告が出る場合があります（署名なしのため）

**Windows Defender警告への対処:**
1. 「詳細情報」をクリック
2. 「実行」ボタンを選択
3. または、ファイルを右クリック→「プロパティ」→「ブロックの解除」にチェック

### 4. 完全機能版（量子アニーリング付き）

1. **Flask APIサーバー起動**
   ```powershell
   cd flask
   .\start_server.ps1
   ```

2. **Flutterアプリ起動**
   ```cmd
   flutter run -d windows
   ```

## ⚙️ 必要な環境

### 1. Web版（推奨）
- **ブラウザ**: Chrome, Firefox, Safari, Edge対応
- **その他**: 特別な設定不要！

### 2. シンプル実行時
- **Python**: 3.8以上

### 3. EXE実行時
- **OS**: Windows 10/11 (64bit)
- **その他**: 特別な設定不要

### 4. 完全機能版実行時
- **Flutter SDK**: 3.8.1以上
- **Python**: 3.8以上
- **Fixstars Amplify APIトークン**: 量子アニーリング機能用

## 🎯 使用方法

### 1. ゲーム開始
1. アプリを起動し、「ゲームスタート」をタップ
2. チェス盤の任意のマスをタップしてナイトを配置

### 2. ナイトの移動
1. 緑色にハイライトされたマスがナイトの移動可能な場所
2. 移動先をタップしてナイトを移動
3. 訪問済みのマスには手数が表示されます

### 3. 量子アニーリングチェック
1. 「トークン設定」ボタンでAmplify APIトークンを入力
2. 「量子チェック」ボタンで解決可能性を判定
3. 量子コンピューターが最適解を探索し、結果を表示

### 4. ゲームクリア
- 全64マスを制覇するとゲームクリア！
- 勝利BGMとお祝いメッセージが表示されます

## 🔧 API仕様

### エンドポイント
- `POST /check_knight_tour` - ナイトツアーの解決可能性チェック
- `GET /health` - サーバーの状態確認

### リクエスト形式
```json
{
  "board_size": 8,
  "current_position": {"x": 2, "y": 4},
  "visited_squares": [
    {"x": 0, "y": 0},
    {"x": 1, "y": 2},
    {"x": 2, "y": 4}
  ],
  "amplify_token": "AE/your-token-here"
}
```

### レスポンス形式
```json
{
  "status": "solvable"  // または "unsolvable"
}
```

## 🎵 アセットファイル

### 音声ファイル
- `assets/sounds/piece_move.mp3` - 駒移動音
- `assets/sounds/victory.mp3` - 勝利BGM
- `assets/sounds/defeat.mp3` - 敗北BGM

### 画像ファイル
- `assets/images/knight.png` - ナイトの駒画像

## 🌐 Web版について

### 自動デプロイメント
このプロジェクトは**GitHub Actions**を使用して自動的にWeb版がデプロイされます：

1. **コードプッシュ** → 自動ビルド開始
2. **Flutter Webビルド** → 最適化されたWeb版を生成  
3. **GitHub Pagesデプロイ** → https://yashi846.github.io/knight-tour-app/ で公開

### Web版の特徴
- ✅ **インストール不要**: ブラウザだけでプレイ
- ✅ **マルチデバイス**: PC・スマホ・タブレット対応
- ✅ **自動更新**: 最新版が常に配信
- ✅ **高速起動**: CDN経由で高速ロード
- ⚠️ **量子機能なし**: Web版では量子アニーリング機能は利用不可

## 🧪 テスト

### APIテスト
```powershell
cd flask
python test_api.py          # API機能テスト
python test_connection.py   # 接続テスト
python test_performance.py  # パフォーマンステスト
```

## 🔍 トラブルシューティング

### よくある問題

1. **EXEファイルが実行できない**
   - Windows Defenderで「WindowsによってPCが保護されました」が表示される場合
   - 「詳細情報」→「実行」を選択
   - または、ファイルを右クリック→「プロパティ」→「ブロックの解除」にチェック

2. **「量子通信エラー」が表示される**
   - Flaskサーバーが起動しているか確認
   - APIエンドポイント(`http://localhost:5000`)にアクセス可能か確認

3. **「トークンが必要です」エラー**
   - 「トークン設定」ボタンからAmplify APIトークンを入力
   - [Amplify Cloud](https://amplify.fixstars.com/)でトークンを取得

4. **音が出ない**
   - 音声ファイルが`assets/sounds/`に存在するか確認
   - pubspec.yamlにアセットが登録されているか確認

5. **Flutterアプリが起動しない**
   ```cmd
   flutter doctor        # Flutter環境の確認
   flutter clean         # キャッシュのクリア
   flutter pub get       # 依存関係の再取得
   ```

### ログの確認
- **Flask**: ターミナルにリアルタイムでログが表示
- **Flutter**: デバッグコンソールでエラーログを確認

## 📁 プロジェクト構成

```
knight-tour-app/
├── lib/main.dart              # メインのFlutterアプリケーション
├── .github/workflows/         # GitHub Actions自動デプロイ設定
├── assets/                    # 画像・音声アセット
├── flask/                     # Flask APIサーバー（量子機能用）
├── simple_launcher.py         # シンプルWebランチャー
├── pubspec.yaml              # Flutter依存関係設定
└── README.md                 # このファイル
```

## 🎮 実行オプション

### 1. Web版（最推奨）🌐
- **[ブラウザでプレイ](https://yashi846.github.io/knight-tour-app/)**
- インストール不要、即プレイ
- 全デバイス対応

### 2. シンプル実行
- `python simple_launcher.py`
- Python環境が必要
- ローカルで安定動作

### 3. EXE実行
- `KnightTourPuzzle.exe`（古いファイル）
- Pythonインストール不要
- Windows専用、手動削除推奨

### 4. 完全機能版
- Flask + Flutter の組み合わせ
- 量子アニーリング機能が利用可能
- 開発者・上級者向け## 🤝 コントリビューション

1. このリポジトリをフォーク
2. フィーチャーブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチにプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## 📄 ライセンス

このプロジェクトはMITライセンスの下で公開されています。

## 🙏 謝辞

- **Flutter Team** - 素晴らしいクロスプラットフォームフレームワーク
- **Fixstars** - Amplify量子アニーリングプラットフォーム
- **チェスコミュニティ** - ナイトツアーパズルのインスピレーション

---

## 📞 サポート

問題が発生した場合は、以下をお試しください：

1. **手動でFlaskサーバーとFlutterアプリを起動**
2. **トラブルシューティング**セクションを確認
3. GitHubのIssuesで問題を報告

**楽しいナイトツアーを！ 🐎♟️**
