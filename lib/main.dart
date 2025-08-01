import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const KnightTourApp());
}

class KnightTourApp extends StatelessWidget {
  const KnightTourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Knight Tour Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // フォント設定を修正
        fontFamily: GoogleFonts.notoSansJp().fontFamily,
        textTheme: GoogleFonts.notoSansJpTextTheme(),
      ),
      home: const TitleScreen(), // タイトル画面を最初に表示
    );
  }
}

// タイトル画面
class TitleScreen extends StatelessWidget {
  const TitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900]!, Colors.blue[600]!, Colors.blue[300]!],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                children: [
                  // タイトル部分
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.castle,
                          size: kIsWeb ? 60 : 80,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ナイト ツアー',
                          style: GoogleFonts.notoSansJp(
                            fontSize: kIsWeb ? 36 : 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2.0,
                          ),
                        ),
                        Text(
                          'Knight Tour Puzzle',
                          style: TextStyle(
                            fontSize: kIsWeb ? 16 : 18,
                            color: Colors.white.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 説明部分
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: Colors.orange[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'ゲームについて',
                              style: GoogleFonts.notoSansJp(
                                fontSize: kIsWeb ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ナイトツアーは、チェスのナイト（騎士）を使った古典的なパズルです。8×8のチェス盤で、ナイトが各マスを一度ずつ訪問し、全64マスを制覇することが目標です。',
                          style: GoogleFonts.notoSansJp(
                            fontSize: kIsWeb ? 14 : 16,
                            height: 1.6,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: Colors.green[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '操作方法',
                              style: GoogleFonts.notoSansJp(
                                fontSize: kIsWeb ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        _buildInstructionItem('1. 任意のマスをタップしてナイトを配置'),
                        _buildInstructionItem('2. 緑色のマスがナイトの移動可能な場所'),
                        _buildInstructionItem('3. ナイトの移動でマスを制覇していこう'),
                        _buildInstructionItem('4. 全64マス制覇でクリア！'),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Icon(
                              Icons.psychology,
                              color: Colors.purple[600],
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '量子アニーリング機能',
                              style: GoogleFonts.notoSansJp(
                                fontSize: kIsWeb ? 18 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '行き詰まった時は「量子アニーリングチェック」ボタンで量子コンピューターが最適解を探索し、解決可能かどうかを判定します。',
                          style: GoogleFonts.notoSansJp(
                            fontSize: kIsWeb ? 14 : 16,
                            height: 1.6,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // スタートボタン
                  SizedBox(
                    width: double.infinity,
                    height: kIsWeb ? 50 : 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChessBoardScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.orange.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'ゲームスタート',
                            style: GoogleFonts.notoSansJp(
                              fontSize: kIsWeb ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSansJp(
                fontSize: kIsWeb ? 14 : 16,
                height: 1.5,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChessBoardScreen extends StatefulWidget {
  const ChessBoardScreen({super.key});

  @override
  State<ChessBoardScreen> createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  // --- 状態管理用の変数 ---
  final int boardSize = 8;
  // { "x,y": moveNumber } の形式で訪問済みマスを管理
  Map<String, int> visitedSquares = {};
  // [x, y] の形式でナイトの現在位置を管理
  List<int>? knightPosition;
  int moveCount = 0;
  bool isLoading = false; // API通信中のローディング状態

  // Amplifyトークン管理
  String? amplifyToken; // Amplifyトークンを保存
  bool get isTokenConfigured =>
      amplifyToken != null && amplifyToken!.isNotEmpty;

  // 音声プレイヤー
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer(); // BGM用の追加プレイヤー

  // 音声を再生するメソッド
  Future<void> _playMoveSound() async {
    try {
      debugPrint('音声ファイルの再生を試行中: assets/sounds/piece_move.mp3');

      // 音量を最大に設定
      await _audioPlayer.setVolume(1.0);

      // 音声ファイルを再生
      await _audioPlayer.play(AssetSource('sounds/piece_move.mp3'));
      debugPrint('✅ チェスの駒配置音を正常に再生しました（音量: 最大）');
    } catch (e) {
      // 音声再生に失敗した場合はデバッグ出力
      debugPrint('❌ 音声再生エラー: $e');
      debugPrint('   ファイルパス確認: assets/sounds/piece_move.mp3');
      debugPrint('   代替音: チェスの駒配置♪');
    }
  }

  // 勝利BGMを再生するメソッド
  Future<void> _playVictoryBGM() async {
    try {
      debugPrint('🎉 勝利BGMの再生を開始します');

      // BGMプレイヤーの音量を設定
      await _bgmPlayer.setVolume(0.8);

      // 勝利BGMを再生
      await _bgmPlayer.play(AssetSource('sounds/victory.mp3'));
      debugPrint('✅ 勝利BGMを正常に再生しました');
    } catch (e) {
      debugPrint('❌ 勝利BGM再生エラー: $e');
      debugPrint('   ファイルパス確認: assets/sounds/victory.mp3');
    }
  }

  // 敗北BGMを再生するメソッド
  Future<void> _playDefeatBGM() async {
    try {
      debugPrint('😔 敗北BGMの再生を開始します');

      // BGMプレイヤーの音量を設定
      await _bgmPlayer.setVolume(0.8);

      // 敗北BGMを再生
      await _bgmPlayer.play(AssetSource('sounds/defeat.mp3'));
      debugPrint('✅ 敗北BGMを正常に再生しました');
    } catch (e) {
      debugPrint('❌ 敗北BGM再生エラー: $e');
      debugPrint('   ファイルパス確認: assets/sounds/defeat.mp3');
    }
  }

  // --- ゲームロジックのメソッド ---

  @override
  void initState() {
    super.initState();
    // オーディオプレイヤーの初期化
    _audioPlayer.setReleaseMode(ReleaseMode.release);
    // 音量を最大に設定
    _audioPlayer.setVolume(1.0);

    // 保存されたトークンを読み込み
    _loadSavedToken();
  }

  // 保存されたトークンを読み込む
  Future<void> _loadSavedToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('amplify_token');
      if (savedToken != null && savedToken.isNotEmpty) {
        setState(() {
          amplifyToken = savedToken;
        });
        debugPrint('保存されたAmplifyトークンを読み込みました');
      }
    } catch (e) {
      debugPrint('トークン読み込みエラー: $e');
    }
  }

  // トークンを保存する
  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('amplify_token', token);
      debugPrint('Amplifyトークンを保存しました');
    } catch (e) {
      debugPrint('トークン保存エラー: $e');
    }
  }

  // トークンを削除する
  Future<void> _removeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('amplify_token');
      debugPrint('Amplifyトークンを削除しました');
    } catch (e) {
      debugPrint('トークン削除エラー: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _bgmPlayer.dispose(); // BGMプレイヤーも解放
    super.dispose();
  }

  // ゲームをリセットする
  void _resetGame() {
    setState(() {
      visitedSquares.clear();
      knightPosition = null;
      moveCount = 0;
    });
  }

  // マスがタップされたときの処理
  void _handleSquareTap(int x, int y) {
    // ローディング中は操作不可
    if (isLoading) return;

    // 1. ナイトがまだ置かれていない場合
    if (knightPosition == null) {
      _playMoveSound(); // 音を再生
      setState(() {
        moveCount = 1;
        knightPosition = [x, y];
        visitedSquares['$x,$y'] = moveCount;
      });
      return;
    }

    // 2. ナイトが既に置かれている場合
    if (_isMoveValid(x, y)) {
      _playMoveSound(); // 音を再生
      setState(() {
        moveCount++;
        knightPosition = [x, y];
        visitedSquares['$x,$y'] = moveCount;
      });

      // 64マス埋まったらクリア
      if (moveCount == boardSize * boardSize) {
        _playVictoryBGM(); // 勝利BGMを再生
        _showGameResultDialog(
          "🎉 ゲームクリア！",
          "おめでとうございます！全てのマスを巡りました。\n\n量子アニーリング技術を使ったナイトツアーパズルを完全制覇です！",
        );
      }
    }
  }

  // ナイトの移動先として有効か判定する
  bool _isMoveValid(int toX, int toY) {
    if (knightPosition == null) return false;

    // すでに訪問済みのマスは無効
    if (visitedSquares.containsKey('$toX,$toY')) {
      return false;
    }

    final fromX = knightPosition![0];
    final fromY = knightPosition![1];
    final dx = (toX - fromX).abs();
    final dy = (toY - fromY).abs();

    // ナイトの移動ルール (L字型)
    return (dx == 1 && dy == 2) || (dx == 2 && dy == 1);
  }

  // 現在位置から移動可能なすべてのマスを取得する
  Set<String> _getValidMoves() {
    if (knightPosition == null) return {};

    final Set<String> validMoves = {};
    final int fromX = knightPosition![0];
    final int fromY = knightPosition![1];

    // ナイトが移動できる8方向をチェック
    const List<List<int>> moves = [
      [1, 2],
      [1, -2],
      [-1, 2],
      [-1, -2],
      [2, 1],
      [2, -1],
      [-2, 1],
      [-2, -1],
    ];

    for (var move in moves) {
      final int toX = fromX + move[0];
      final int toY = fromY + move[1];

      // 盤面の範囲内かチェック
      if (toX >= 0 && toX < boardSize && toY >= 0 && toY < boardSize) {
        if (!visitedSquares.containsKey('$toX,$toY')) {
          validMoves.add('$toX,$toY');
        }
      }
    }
    return validMoves;
  }

  // --- API連携のメソッド ---

  // プラットフォームに応じたAPIエンドポイントを取得
  String get apiBaseUrl {
    if (kIsWeb) {
      // Web版の場合
      return 'http://localhost:5000';
    } else if (Platform.isAndroid) {
      // Androidエミュレーターの場合は10.0.2.2を使用
      return 'http://10.0.2.2:5000';
    } else {
      // iOS, Windows, macOS, Linux の場合
      return 'http://localhost:5000';
    }
  }

  // 量子アニーリング判定APIを呼び出す
  Future<void> _checkGameOver() async {
    if (knightPosition == null) {
      _showInfoSnackBar("ナイトを配置してからチェックしてください。");
      return;
    }

    // Amplifyトークンが設定されていない場合はダイアログを表示
    if (!isTokenConfigured) {
      _showGameResultDialog(
        "トークンが必要です",
        "量子アニーリングチェックを実行するには、AmplifyのAPIトークンが必要です。\n\nトークン設定ボタンから設定してください。",
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    // プラットフォームに応じたAPIエンドポイント
    final String apiUrl = '$apiBaseUrl/check_knight_tour';

    // APIに送信するデータを作成（Amplifyトークンを含める）
    final requestBody = jsonEncode({
      'board_size': boardSize,
      'current_position': {'x': knightPosition![0], 'y': knightPosition![1]},
      'visited_squares': visitedSquares.keys.map((key) {
        final parts = key.split(',');
        return {'x': int.parse(parts[0]), 'y': int.parse(parts[1])};
      }).toList(),
      'amplify_token': amplifyToken, // Amplifyトークンを追加
    });

    try {
      // デバッグ情報を表示
      debugPrint('接続先API URL: $apiUrl');
      debugPrint('リクエストボディ: $requestBody');
      debugPrint('API呼び出し開始: ${DateTime.now()}');

      // APIにPOSTリクエストを送信
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(const Duration(minutes: 10)); // タイムアウトを10分に延長

      debugPrint('API呼び出し完了: ${DateTime.now()}');
      debugPrint('レスポンスステータス: ${response.statusCode}');
      debugPrint('レスポンスボディ: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['status'];
        if (status == 'solvable') {
          _showGameResultDialog(
            "量子アニーリング結果",
            "量子コンピューターの計算により、まだ続行可能であることが判明しました！頑張ってください。",
          );
        } else {
          _playDefeatBGM(); // 敗北BGMを再生
          _showGameResultDialog(
            "😔 量子アニーリング結果",
            "量子アニーリングの結果、これ以上進める手はありません。\n\nゲームオーバーです。リセットして再挑戦してください！",
          );
        }
      } else {
        // サーバーからのエラーレスポンス
        debugPrint('量子アニーリングAPIエラー詳細: ${response.body}');
        _showGameResultDialog(
          "量子アニーリングエラー",
          "量子コンピューターからエラーが返されました (コード: ${response.statusCode})\n詳細: ${response.body}",
        );
      }
    } catch (e) {
      // タイムアウトやネットワークエラー
      debugPrint('量子アニーリング通信エラー: $e');
      _showGameResultDialog(
        "量子通信エラー",
        "量子コンピューターに接続できませんでした。\n\n接続先: $apiUrl\n\nプラットフォーム: ${Platform.operatingSystem}\n\nエラー詳細: $e",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // シンプルなAPI接続テスト
  Future<void> _testApiConnection() async {
    setState(() {
      isLoading = true;
    });

    // ヘルスチェックエンドポイント
    final String healthUrl = '$apiBaseUrl/health';

    try {
      debugPrint('ヘルスチェックURL: $healthUrl');

      final response = await http
          .get(Uri.parse(healthUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _showGameResultDialog(
          "接続テスト成功",
          "APIサーバーとの接続が確認されました。\n\nレスポンス: ${responseBody['status']}",
        );
      } else {
        _showGameResultDialog(
          "接続テストエラー",
          "サーバーからエラーが返されました (コード: ${response.statusCode})",
        );
      }
    } catch (e) {
      debugPrint('ヘルスチェックエラー: $e');
      _showGameResultDialog(
        "接続テストエラー",
        "APIサーバーに接続できませんでした。\n\n接続先: $healthUrl\n\nエラー詳細: $e",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Amplifyトークン設定ダイアログを表示
  Future<void> _showTokenConfigDialog() async {
    final TextEditingController tokenController = TextEditingController();

    // 既存のトークンがある場合は表示
    if (amplifyToken != null) {
      tokenController.text = amplifyToken!;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.key, color: Colors.purple[600]),
            const SizedBox(width: 8),
            const Text('Amplifyトークン設定'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fixstars AmplifyのAPIトークンを入力してください。',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'トークンの取得方法',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '1. Amplify クラウドにログイン\n'
                    '2. マイページにアクセス\n'
                    '3. APIトークンをコピー',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: tokenController,
              decoration: InputDecoration(
                labelText: 'APIトークン',
                hintText: 'AE/...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.vpn_key),
                helperText: '例: AE/xxxxxxxxxxxxxxxx',
                helperStyle: TextStyle(color: Colors.grey[600]),
              ),
              obscureText: true,
              maxLines: 1,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green.shade200),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.green[700],
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'トークンはアプリ内に保存され、検証は行いません',
                      style: TextStyle(fontSize: 12, color: Colors.green[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          if (amplifyToken != null)
            TextButton(
              onPressed: () async {
                await _removeToken();
                setState(() {
                  amplifyToken = null;
                });
                Navigator.of(context).pop();
                _showInfoSnackBar('トークンが削除されました');
              },
              child: Text('削除', style: TextStyle(color: Colors.red[600])),
            ),
          ElevatedButton(
            onPressed: () async {
              final token = tokenController.text.trim();
              if (token.isEmpty) {
                _showInfoSnackBar('トークンを入力してください');
                return;
              }

              await _saveToken(token);
              setState(() {
                amplifyToken = token;
              });

              Navigator.of(context).pop();
              _showInfoSnackBar('トークンが保存されました');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  // --- UI表示用のヘルパーメソッド ---

  void _showGameResultDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // --- UI構築 ---

  @override
  Widget build(BuildContext context) {
    final validMoves = _getValidMoves();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ナイトツアーパズル',
          style: GoogleFonts.notoSansJp(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const TitleScreen()),
                (route) => false,
              );
            },
            tooltip: 'タイトル画面へ',
          ),
        ],
      ),
      body: SingleChildScrollView(
        // ★ 追加
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ゲーム情報
              Text(
                '手数: $moveCount / ${boardSize * boardSize}',
                style: GoogleFonts.notoSansJp(
                  fontSize: kIsWeb ? 20 : 24, // Webでは少し小さく
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // チェス盤
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: kIsWeb
                      ? MediaQuery.of(context).size.height *
                            0.6 // Webでは画面高さの60%
                      : MediaQuery.of(context).size.width * 0.9,
                  maxHeight: kIsWeb
                      ? MediaQuery.of(context).size.height *
                            0.6 // Webでは画面高さの60%
                      : MediaQuery.of(context).size.width * 0.9,
                ),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), // ★ 追加：内部スクロール禁止
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: boardSize,
                        ),
                        itemCount: boardSize * boardSize,
                        itemBuilder: (context, index) {
                          final x = index % boardSize;
                          final y = index ~/ boardSize;
                          final key = '$x,$y';
                          final isVisited = visitedSquares.containsKey(key);
                          final isKnightHere =
                              knightPosition != null &&
                              knightPosition![0] == x &&
                              knightPosition![1] == y;
                          final isValidMove = validMoves.contains(key);

                          Color squareColor = (x + y) % 2 == 0
                              ? Colors.grey[200]!
                              : Colors.grey[500]!;

                          if (isValidMove) {
                            squareColor = Colors.green[300]!;
                          }
                          if (isKnightHere) {
                            squareColor = Colors.blue[400]!;
                          }

                          return GestureDetector(
                            onTap: () => _handleSquareTap(x, y),
                            child: Container(
                              decoration: BoxDecoration(
                                color: squareColor,
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 0.5,
                                ),
                              ),
                              child: Center(
                                child: Stack(
                                  children: [
                                    if (isVisited)
                                      Center(
                                        child: Text(
                                          visitedSquares[key].toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isKnightHere
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    if (isKnightHere)
                                      Center(
                                        child: Container(
                                          width: kIsWeb ? 40 : 50,
                                          height: kIsWeb ? 40 : 50,
                                          child: Image.asset(
                                            'assets/images/knight.png',
                                            color: Colors.white,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 以下そのまま
              if (knightPosition == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'チェス盤の任意のマスをタップしてナイトを配置してください',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansJp(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (isLoading)
                Column(
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '量子アニーリングによる最適化計算中...\nしばらくお待ちください',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansJp(
                        fontSize: 16,
                        color: Colors.purple[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _resetGame,
                          icon: const Icon(Icons.refresh),
                          label: Text('リセット', style: GoogleFonts.notoSansJp()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testApiConnection,
                          icon: const Icon(Icons.wifi_tethering),
                          label: Text('接続テスト', style: GoogleFonts.notoSansJp()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _showTokenConfigDialog,
                          icon: Icon(
                            isTokenConfigured ? Icons.key : Icons.key_off,
                            size: 20,
                          ),
                          label: Text(
                            'トークン設定',
                            style: GoogleFonts.notoSansJp(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTokenConfigured
                                ? Colors.blue
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(140, 36),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: (isLoading || !isTokenConfigured)
                              ? null
                              : _checkGameOver,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Icon(
                                  isTokenConfigured
                                      ? Icons.psychology
                                      : Icons.lock,
                                  size: 20,
                                ),
                          label: Text(
                            isLoading
                                ? '量子計算中...'
                                : isTokenConfigured
                                ? '量子チェック'
                                : 'トークン必要',
                            style: GoogleFonts.notoSansJp(fontSize: 14),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTokenConfigured
                                ? Colors.purple
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(140, 36),
                          ),
                        ),
                      ],
                    ),
                    if (isTokenConfigured)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border.all(color: Colors.green.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Amplifyトークンが設定済み',
                                style: GoogleFonts.notoSansJp(
                                  fontSize: 12,
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            border: Border.all(color: Colors.orange.shade300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber,
                                size: 16,
                                color: Colors.orange[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'トークンを設定してください',
                                style: GoogleFonts.notoSansJp(
                                  fontSize: 12,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
