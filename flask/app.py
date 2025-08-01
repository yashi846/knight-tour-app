from flask import Flask, request, jsonify
from flask_cors import CORS
import numpy as np
import math
from amplify import VariableGenerator, equal_to, sum_poly, FixstarsClient, solve
from datetime import timedelta
import asyncio
import threading
import concurrent.futures
import logging

app = Flask(__name__)
# CORSの設定を明示的に行う（Flutter WebやローカルFlutterアプリからのリクエストを許可）
CORS(app, origins=["*"], allow_headers=["Content-Type"], methods=["GET", "POST", "OPTIONS"])

# ログ設定
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class KnightTourSolver:
    def __init__(self, board_size=8):
        self.board_size = board_size
        self.NUM_BOARD = board_size * board_size
        self.d_moves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
        
    def solve_knight_tour(self, visited_squares, amplify_token=None):
        """
        ナイト・ツアーの解決可能性を判定する
        """
        try:
            gen = VariableGenerator()
            q = gen.array("Binary", shape=(self.NUM_BOARD, self.board_size, self.board_size))
            
            # 基本制約の設定
            constraints = 0
            
            # 制約1: 各手で1マスだけ指す
            for n in range(self.NUM_BOARD):
                constraints += equal_to(sum_poly([q[n, i, j] for i in range(self.board_size) for j in range(self.board_size)]), 1)
            
            # 制約2: 各マスは1回だけ指す
            for i in range(self.board_size):
                for j in range(self.board_size):
                    constraints += equal_to(sum_poly([q[n, i, j] for n in range(self.NUM_BOARD)]), 1)
            
            # 制約3: 既に訪問済みの手を固定
            for step, pos in enumerate(visited_squares):
                constraints += equal_to(q[step, pos['x'], pos['y']], 1)
            
            # ナイトの移動を促進する目的関数
            objective = 0
            for n in range(self.NUM_BOARD - 1):
                legal_moves = 0
                for i in range(self.board_size):
                    for j in range(self.board_size):
                        for d in self.d_moves:
                            ni, nj = i + d[0], j + d[1]
                            if 0 <= ni < self.board_size and 0 <= nj < self.board_size:
                                legal_moves += q[n, i, j] * q[n+1, ni, nj]
                objective += legal_moves
            
            objective = -objective  # 目的関数は最大化
            
            # モデル作成と求解
            model = constraints + objective
            client = FixstarsClient()
            
            # Amplifyトークンの設定
            if amplify_token:
                client.token = amplify_token
                logger.info("クライアントから提供されたAmplifyトークンを使用")
            else:
                logger.error("Amplifyトークンが提供されていません")
                raise ValueError("Amplifyトークンが必要です")
            
            timeout_seconds = 100  # 100s
                
            client.parameters.timeout = timedelta(seconds=timeout_seconds)
            
            logger.info(f"量子アニーリング求解開始: visited_squares={len(visited_squares)}手, timeout={timeout_seconds}秒")
            result = solve(model, client)
            logger.info(f"量子アニーリング求解完了: result.best={'有' if result.best else '無'}")
            
            if result.best is None:
                return False
            
            # 結果の検証
            best_solution = result.best.values
            q_values = q.evaluate(best_solution)
            
            # 経路の検証
            positions = []
            for n in range(self.NUM_BOARD):
                pos = None
                for i in range(self.board_size):
                    for j in range(self.board_size):
                        if q_values[n, i, j] == 1:
                            pos = (i, j)
                            break
                    if pos:
                        break
                positions.append(pos)
            
            # ナイトの動きが正しいかチェック
            valid_tour = True
            for i in range(len(visited_squares) - 1, self.NUM_BOARD - 1):
                if positions[i] is None or positions[i + 1] is None:
                    valid_tour = False
                    break
                x1, y1 = positions[i]
                x2, y2 = positions[i + 1]
                dx, dy = abs(x2 - x1), abs(y2 - y1)
                if not ((dx == 1 and dy == 2) or (dx == 2 and dy == 1)):
                    valid_tour = False
                    break
            
            return valid_tour
            
        except Exception as e:
            logger.error(f"ナイト・ツアー解決中にエラーが発生: {str(e)}")
            return False

def run_solver_async(board_size, visited_squares, amplify_token=None):
    """
    非同期でナイト・ツアーソルバーを実行
    """
    solver = KnightTourSolver(board_size)
    return solver.solve_knight_tour(visited_squares, amplify_token)

@app.route('/check_knight_tour', methods=['POST'])
def check_knight_tour():
    """
    ナイト・ツアーの解決可能性をチェックするAPI
    """
    try:
        # リクエストデータの検証
        data = request.get_json()
        if not data:
            return jsonify({'error': 'リクエストボディが空です'}), 400
        
        # 必要なフィールドの確認
        required_fields = ['board_size', 'current_position', 'visited_squares']
        for field in required_fields:
            if field not in data:
                return jsonify({'error': f'必須フィールド "{field}" が見つかりません'}), 400
        
        board_size = data['board_size']
        current_position = data['current_position']
        visited_squares = data['visited_squares']
        amplify_token = data.get('amplify_token')  # オプショナルフィールド
        
        # Amplifyトークンのログ出力（セキュリティ上、一部のみ表示）
        if amplify_token:
            token_preview = amplify_token[:10] + "..." if len(amplify_token) > 10 else amplify_token
            logger.info(f"Amplifyトークンを受信: {token_preview}")
        else:
            logger.warning("Amplifyトークンが提供されていません。量子アニーリングの実行にはトークンが必要です。")
        
        # データの妥当性チェック
        if not isinstance(board_size, int) or board_size < 5 or board_size > 10:
            return jsonify({'error': 'board_sizeは5から10の整数である必要があります'}), 400
        
        if not isinstance(current_position, dict) or 'x' not in current_position or 'y' not in current_position:
            return jsonify({'error': 'current_positionは{x, y}の形式である必要があります'}), 400
        
        if not isinstance(visited_squares, list):
            return jsonify({'error': 'visited_squaresは配列である必要があります'}), 400
        
        # 座標の範囲チェック
        for pos in visited_squares:
            if not isinstance(pos, dict) or 'x' not in pos or 'y' not in pos:
                return jsonify({'error': 'visited_squaresの各要素は{x, y}の形式である必要があります'}), 400
            if pos['x'] < 0 or pos['x'] >= board_size or pos['y'] < 0 or pos['y'] >= board_size:
                return jsonify({'error': f'座標が盤面の範囲外です: ({pos["x"]}, {pos["y"]})'}), 400
        
        # current_positionがvisited_squaresの最後の要素と一致するかチェック
        if visited_squares:
            last_pos = visited_squares[-1]
            if current_position['x'] != last_pos['x'] or current_position['y'] != last_pos['y']:
                return jsonify({'error': 'current_positionがvisited_squaresの最後の位置と一致しません'}), 400
        
        logger.info(f"ナイト・ツアーチェック開始: board_size={board_size}, visited_squares={len(visited_squares)}手")
        
        # 早期チェック: 移動可能なマスが存在するかを確認
        current_x, current_y = current_position['x'], current_position['y']
        visited_positions = set((pos['x'], pos['y']) for pos in visited_squares)
        
        # ナイトの8方向の移動
        knight_moves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
        possible_moves = []
        
        for dx, dy in knight_moves:
            next_x, next_y = current_x + dx, current_y + dy
            if (0 <= next_x < board_size and 0 <= next_y < board_size and 
                (next_x, next_y) not in visited_positions):
                possible_moves.append((next_x, next_y))
        
        # 移動可能なマスがない場合は即座にunsolvableを返す
        if not possible_moves:
            logger.info("移動可能なマスが存在しないため、ゲームオーバー")
            return jsonify({'status': 'unsolvable'}), 200
        
        # 非同期でソルバーを実行
        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(run_solver_async, board_size, visited_squares, amplify_token)
            try:
                # 量子アニーリングのタイムアウト + バッファ時間を設定
                executor_timeout = 100 + 30  # 量子アニーリング100秒 + バッファ30秒
                
                logger.info(f"実行タイムアウト設定: {executor_timeout}秒")
                is_solvable = future.result(timeout=executor_timeout)
                
                status = "solvable" if is_solvable else "unsolvable"
                logger.info(f"ナイト・ツアーチェック完了: status={status}")
                
                return jsonify({'status': status}), 200
                
            except concurrent.futures.TimeoutError:
                logger.warning("ナイト・ツアーチェックがタイムアウトしました")
                return jsonify({'error': 'タイムアウトが発生しました。処理に時間がかかりすぎています。'}), 408
            
    except Exception as e:
        logger.error(f"APIエラー: {str(e)}")
        return jsonify({'error': 'サーバー内部エラーが発生しました'}), 500

@app.route('/health', methods=['GET'])
def health_check():
    """
    ヘルスチェック用エンドポイント
    """
    return jsonify({'status': 'healthy'}), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'エンドポイントが見つかりません'}), 404

@app.errorhandler(405)
def method_not_allowed(error):
    return jsonify({'error': 'メソッドが許可されていません'}), 405

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'サーバー内部エラーが発生しました'}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
