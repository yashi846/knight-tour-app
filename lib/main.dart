import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      ),
      home: const ChessBoardScreen(),
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

  // --- ゲームロジックのメソッド ---

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
      setState(() {
        moveCount = 1;
        knightPosition = [x, y];
        visitedSquares['$x,$y'] = moveCount;
      });
      return;
    }

    // 2. ナイトが既に置かれている場合
    if (_isMoveValid(x, y)) {
      setState(() {
        moveCount++;
        knightPosition = [x, y];
        visitedSquares['$x,$y'] = moveCount;
      });

      // 64マス埋まったらクリア
      if (moveCount == boardSize * boardSize) {
        _showGameResultDialog("ゲームクリア！", "おめでとうございます！全てのマスを巡りました。");
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

  // ゲームオーバー判定APIを呼び出す
  Future<void> _checkGameOver() async {
    if (knightPosition == null) {
      _showInfoSnackBar("ナイトを配置してからチェックしてください。");
      return;
    }

    setState(() {
      isLoading = true;
    });

    // ローカルFlaskサーバーのAPIエンドポイント
    const String apiUrl = 'http://localhost:5000/check_knight_tour';

    // APIに送信するデータを作成
    final requestBody = jsonEncode({
      'board_size': boardSize,
      'current_position': {'x': knightPosition![0], 'y': knightPosition![1]},
      'visited_squares': visitedSquares.keys.map((key) {
        final parts = key.split(',');
        return {'x': int.parse(parts[0]), 'y': int.parse(parts[1])};
      }).toList(),
    });

    try {
      // APIにPOSTリクエストを送信
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final status = responseBody['status'];
        if (status == 'solvable') {
          _showGameResultDialog("チェック結果", "まだ続行可能です！頑張ってください。");
        } else {
          _showGameResultDialog("チェック結果", "ゲームオーバーです。これ以上進める手はありません。");
        }
      } else {
        // サーバーからのエラーレスポンス
        _showGameResultDialog(
          "APIエラー",
          "サーバーからエラーが返されました (コード: ${response.statusCode})",
        );
      }
    } catch (e) {
      // タイムアウトやネットワークエラー
      _showGameResultDialog(
        "通信エラー",
        "APIに接続できませんでした。ネットワーク接続を確認するか、URLが正しいか確認してください。\n\nエラー詳細: $e",
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
        title: const Text('ナイトツアーパズル'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // チェス盤
              ConstrainedBox(
                // ★ 追加
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.width * 0.9,
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
                                        child: Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.white,
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'チェス盤の任意のマスをタップしてナイトを配置してください',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 20),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _resetGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('リセット'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _checkGameOver,
                      icon: const Icon(Icons.api),
                      label: const Text('ゲームオーバーチェック'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
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
