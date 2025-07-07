import requests
import json

def test_knight_tour_api():
    """
    ナイト・ツアーAPIのテスト
    """
    # APIエンドポイント
    url = "http://localhost:5000/check_knight_tour"
    
    # テストデータ1: 解決可能なケース
    test_data_1 = {
        "board_size": 8,
        "current_position": {"x": 2, "y": 4},
        "visited_squares": [
            {"x": 0, "y": 0},
            {"x": 1, "y": 2},
            {"x": 2, "y": 4}
        ]
    }
    
    # テストデータ2: より複雑なケース
    test_data_2 = {
        "board_size": 8,
        "current_position": {"x": 1, "y": 0},
        "visited_squares": [
            {"x": 0, "y": 0},
            {"x": 1, "y": 2},
            {"x": 3, "y": 3},
            {"x": 4, "y": 1},
            {"x": 2, "y": 2},
            {"x": 1, "y": 0}
        ]
    }
    
    # テストデータ3: 小さな盤面
    test_data_3 = {
        "board_size": 5,
        "current_position": {"x": 0, "y": 0},
        "visited_squares": [
            {"x": 0, "y": 0}
        ]
    }
    
    test_cases = [
        ("テストケース1: 基本的なケース", test_data_1),
        ("テストケース2: 複雑なケース", test_data_2),
        ("テストケース3: 5x5盤面", test_data_3)
    ]
    
    for test_name, test_data in test_cases:
        print(f"\n{test_name}")
        print(f"リクエストデータ: {json.dumps(test_data, ensure_ascii=False)}")
        
        try:
            response = requests.post(url, json=test_data, timeout=60)
            print(f"HTTPステータスコード: {response.status_code}")
            print(f"レスポンス: {response.json()}")
            
        except requests.exceptions.Timeout:
            print("タイムアウトエラー")
        except requests.exceptions.ConnectionError:
            print("接続エラー - サーバーが起動していない可能性があります")
        except requests.exceptions.RequestException as e:
            print(f"リクエストエラー: {e}")
        except Exception as e:
            print(f"予期しないエラー: {e}")

def test_health_check():
    """
    ヘルスチェックAPIのテスト
    """
    print("\n=== ヘルスチェックテスト ===")
    try:
        response = requests.get("http://localhost:5000/health", timeout=5)
        print(f"HTTPステータスコード: {response.status_code}")
        print(f"レスポンス: {response.json()}")
    except Exception as e:
        print(f"ヘルスチェックエラー: {e}")

def test_error_cases():
    """
    エラーケースのテスト
    """
    print("\n=== エラーケーステスト ===")
    url = "http://localhost:5000/check_knight_tour"
    
    error_cases = [
        ("空のリクエスト", {}),
        ("必須フィールド不足", {"board_size": 8}),
        ("不正な盤面サイズ", {"board_size": 20, "current_position": {"x": 0, "y": 0}, "visited_squares": []}),
        ("範囲外の座標", {"board_size": 8, "current_position": {"x": 10, "y": 10}, "visited_squares": [{"x": 10, "y": 10}]})
    ]
    
    for test_name, test_data in error_cases:
        print(f"\n{test_name}")
        try:
            response = requests.post(url, json=test_data, timeout=10)
            print(f"HTTPステータスコード: {response.status_code}")
            print(f"レスポンス: {response.json()}")
        except Exception as e:
            print(f"エラー: {e}")

if __name__ == "__main__":
    print("=== ナイト・ツアーAPI テスト ===")
    
    # ヘルスチェック
    test_health_check()
    
    # 基本的なテスト
    test_knight_tour_api()
    
    # エラーケースのテスト
    test_error_cases()
