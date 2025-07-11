import requests
import json
import time

def test_early_game():
    """序盤のテスト - 早期判定が動作するかチェック"""
    url = "http://localhost:5000/check_knight_tour"
    
    # テストケース1: 1手目 - solvableであるべき
    test_data = {
        "board_size": 8,
        "current_position": {"x": 0, "y": 0},
        "visited_squares": [{"x": 0, "y": 0}]
    }
    
    print("=== 序盤テスト (1手目) ===")
    print(f"リクエストデータ: {json.dumps(test_data, indent=2)}")
    
    start_time = time.time()
    
    try:
        response = requests.post(url, json=test_data, timeout=30)
        end_time = time.time()
        processing_time = end_time - start_time
        
        print(f"処理時間: {processing_time:.2f}秒")
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            result = response.json()
            print(f"結果: {result['status']}")
            print(f"期待結果: solvable")
            print(f"成功: {'✓' if result['status'] == 'solvable' else '✗'}")
        
        return processing_time < 5  # 5秒以内であることを期待
        
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        return False

def test_no_moves():
    """移動不可能なケースのテスト"""
    url = "http://localhost:5000/check_knight_tour"
    
    # 角から始めて、可能な移動先を全て埋めるケース
    test_data = {
        "board_size": 8,
        "current_position": {"x": 0, "y": 1},
        "visited_squares": [
            {"x": 0, "y": 0},  # 1手目: 角
            {"x": 0, "y": 1}   # 2手目: current_position
        ]
    }
    
    # (0,1)から移動可能な全ての座標を埋める
    possible_moves = []
    knight_moves = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
    for dx, dy in knight_moves:
        nx, ny = 0 + dx, 1 + dy
        if 0 <= nx < 8 and 0 <= ny < 8:
            possible_moves.append({"x": nx, "y": ny})
    
    # 既存の訪問済み座標以外の移動可能座標を全て追加
    for move in possible_moves:
        if move not in test_data["visited_squares"]:
            test_data["visited_squares"].append(move)
    
    print("\n=== 移動不可能テスト ===")
    print(f"リクエストデータ: {json.dumps(test_data, indent=2)}")
    
    start_time = time.time()
    
    try:
        response = requests.post(url, json=test_data, timeout=30)
        end_time = time.time()
        processing_time = end_time - start_time
        
        print(f"処理時間: {processing_time:.2f}秒")
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            result = response.json()
            print(f"結果: {result['status']}")
            print(f"期待結果: unsolvable")
            print(f"成功: {'✓' if result['status'] == 'unsolvable' else '✗'}")
        
        return processing_time < 2  # 即座に判定されることを期待
        
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        return False

if __name__ == "__main__":
    print("APIパフォーマンステスト開始...")
    
    # ヘルスチェック
    try:
        health_response = requests.get("http://localhost:5000/health", timeout=5)
        print(f"ヘルスチェック: {health_response.status_code} - {health_response.text}")
    except Exception as e:
        print(f"サーバーに接続できません: {e}")
        exit(1)
    
    # テスト実行
    test1_success = test_early_game()
    test2_success = test_no_moves()
    
    print(f"\n=== テスト結果 ===")
    print(f"序盤テスト: {'成功' if test1_success else '失敗'}")
    print(f"移動不可能テスト: {'成功' if test2_success else '失敗'}")
    
    if test1_success and test2_success:
        print("✓ 全テスト成功！改善が効果的です。")
    else:
        print("✗ 一部テストが失敗しました。")
