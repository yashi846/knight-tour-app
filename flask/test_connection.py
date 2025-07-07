#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FlaskサーバーとFlutterアプリの通信テスト用スクリプト
"""

import requests
import json
import time

def test_flask_server():
    """FlaskサーバーのAPIエンドポイントをテストする"""
    base_url = "http://localhost:5000"
    
    print("=== FlaskサーバーAPIテスト ===")
    
    # 1. ヘルスチェック
    print("\n1. ヘルスチェック...")
    try:
        response = requests.get(f"{base_url}/health", timeout=5)
        if response.status_code == 200:
            print("✓ ヘルスチェック成功")
            print(f"  レスポンス: {response.json()}")
        else:
            print(f"✗ ヘルスチェック失敗: {response.status_code}")
    except Exception as e:
        print(f"✗ ヘルスチェックエラー: {e}")
        return False
    
    # 2. ナイトツアーAPIテスト
    print("\n2. ナイトツアーAPIテスト...")
    
    # テストデータ
    test_data = {
        "board_size": 8,
        "current_position": {"x": 0, "y": 0},
        "visited_squares": [
            {"x": 0, "y": 0}
        ]
    }
    
    try:
        response = requests.post(
            f"{base_url}/check_knight_tour",
            headers={"Content-Type": "application/json"},
            json=test_data,
            timeout=30
        )
        
        if response.status_code == 200:
            print("✓ ナイトツアーAPI成功")
            result = response.json()
            print(f"  レスポンス: {result}")
            if 'status' in result:
                print(f"  ステータス: {result['status']}")
        else:
            print(f"✗ ナイトツアーAPI失敗: {response.status_code}")
            print(f"  レスポンス: {response.text}")
    except Exception as e:
        print(f"✗ ナイトツアーAPIエラー: {e}")
    
    return True

def test_cors():
    """CORSの設定をテストする"""
    print("\n=== CORS設定テスト ===")
    
    base_url = "http://localhost:5000"
    
    try:
        # プリフライトリクエストをシミュレート
        response = requests.options(
            f"{base_url}/check_knight_tour",
            headers={
                "Origin": "http://localhost:3000",
                "Access-Control-Request-Method": "POST",
                "Access-Control-Request-Headers": "Content-Type"
            },
            timeout=5
        )
        
        print(f"OPTIONSリクエスト結果: {response.status_code}")
        print(f"CORS Headers: {dict(response.headers)}")
        
        if response.status_code == 200:
            print("✓ CORS設定正常")
        else:
            print("✗ CORS設定に問題がある可能性があります")
            
    except Exception as e:
        print(f"✗ CORSテストエラー: {e}")

def check_server_running():
    """サーバーが動作しているかチェック"""
    print("=== サーバー状態チェック ===")
    
    try:
        response = requests.get("http://localhost:5000/health", timeout=3)
        if response.status_code == 200:
            print("✓ Flaskサーバーが動作中")
            return True
        else:
            print(f"✗ サーバーからの応答エラー: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("✗ サーバーに接続できません")
        print("  Flaskサーバーを起動してください:")
        print("  python app.py または start_server.ps1 を実行")
        return False
    except Exception as e:
        print(f"✗ サーバーチェックエラー: {e}")
        return False

if __name__ == "__main__":
    print("FlaskサーバーとFlutterアプリの通信テスト")
    print("=" * 50)
    
    # サーバーの状態確認
    if not check_server_running():
        print("\n終了: サーバーが動作していません")
        exit(1)
    
    # APIテスト実行
    test_flask_server()
    test_cors()
    
    print("\n" + "=" * 50)
    print("テスト完了")
    print("\nFlutterアプリからの接続:")
    print("1. Flaskサーバーがポート5000で動作していることを確認")
    print("2. FlutterアプリでAPIエンドポイントが http://localhost:5000/check_knight_tour に設定されていることを確認")
    print("3. Flutterアプリでゲームオーバーチェックボタンを押してテスト")
