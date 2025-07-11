import requests
import json
import time

def test_api():
    url = "http://localhost:5000/check_knight_tour"
    
    # テストケース1: 1手目のテスト（解決可能であるべき）
    test_data = {
        "board_size": 8,
        "current_position": {"x": 0, "y": 0},
        "visited_squares": [{"x": 0, "y": 0}]
    }
    
    print("APIテスト開始...")
    print(f"リクエストデータ: {json.dumps(test_data, indent=2)}")
    
    start_time = time.time()
    
    try:
        response = requests.post(
            url, 
            json=test_data,
            timeout=60  # 1分のタイムアウト
        )
        
        end_time = time.time()
        processing_time = end_time - start_time
        
        print(f"処理時間: {processing_time:.2f}秒")
        print(f"ステータスコード: {response.status_code}")
        print(f"レスポンス: {response.text}")
        
        if response.status_code == 200:
            result = response.json()
            print(f"結果: {result['status']}")
        
    except requests.exceptions.Timeout:
        print("APIリクエストがタイムアウトしました")
    except Exception as e:
        print(f"エラーが発生しました: {e}")

if __name__ == "__main__":
    test_api()
