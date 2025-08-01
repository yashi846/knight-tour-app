# Knight Tour Puzzle - Simple Web Launcher
# EXE用のシンプルなWebサーバーランチャー

import os
import sys
import threading
import webbrowser
import time
from http.server import HTTPServer, SimpleHTTPRequestHandler
import socket

class SimpleWebLauncher:
    def __init__(self):
        self.web_port = 8080
        self.web_server = None
        
        # PyInstallerでパッケージ化された場合の対応
        if getattr(sys, 'frozen', False):
            self.project_root = sys._MEIPASS
        else:
            self.project_root = os.path.dirname(os.path.abspath(__file__))
    
    def find_free_port(self, start_port=8080):
        """利用可能なポートを見つける"""
        for port in range(start_port, start_port + 10):
            try:
                with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                    s.bind(('localhost', port))
                    return port
            except OSError:
                continue
        return start_port
    
    def start_web_server(self):
        """Flutter Web版を配信するHTTPサーバーを起動"""
        try:
            web_dir = os.path.join(self.project_root, "build", "web")
            print(f"Looking for web directory: {web_dir}")
            
            if not os.path.exists(web_dir):
                print(f"❌ Web build not found: {web_dir}")
                return False
                
            # 利用可能なポートを見つける
            self.web_port = self.find_free_port(8080)
            
            os.chdir(web_dir)
            
            class CustomHandler(SimpleHTTPRequestHandler):
                def end_headers(self):
                    self.send_header('Cross-Origin-Embedder-Policy', 'credentialless')
                    self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
                    super().end_headers()
                
                def log_message(self, format, *args):
                    pass  # ログを無効化
            
            self.web_server = HTTPServer(('localhost', self.web_port), CustomHandler)
            print(f"✅ Web server started on port {self.web_port}")
            
            # サーバーを別スレッドで起動
            server_thread = threading.Thread(target=self.web_server.serve_forever)
            server_thread.daemon = True
            server_thread.start()
            
            return True
            
        except Exception as e:
            print(f"❌ Web server failed to start: {e}")
            return False
    
    def open_browser(self):
        """ブラウザでアプリを開く"""
        try:
            time.sleep(2)
            url = f"http://localhost:{self.web_port}"
            print(f"🌐 Opening browser: {url}")
            webbrowser.open(url)
        except Exception as e:
            print(f"⚠️ Browser failed to open: {e}")
            print(f"Manually visit: http://localhost:{self.web_port}")
    
    def cleanup(self):
        """サーバーを停止"""
        if self.web_server:
            self.web_server.shutdown()
            print("🛑 Web server stopped")
    
    def run(self):
        """メイン実行"""
        print("==========================================")
        print("   Knight Tour Puzzle")
        print("==========================================")
        print()
        
        try:
            if not self.start_web_server():
                input("Press Enter to exit...")
                return
            
            # ブラウザを開く
            browser_thread = threading.Thread(target=self.open_browser)
            browser_thread.start()
            
            print()
            print("🎮 Knight Tour Puzzle is running!")
            print(f"   Web App: http://localhost:{self.web_port}")
            print()
            print("Note: Quantum features require API server")
            print("Press Ctrl+C to exit...")
            
            # メインスレッドで待機
            try:
                while True:
                    time.sleep(1)
            except KeyboardInterrupt:
                print("\n🛑 Shutting down...")
                
        except Exception as e:
            print(f"❌ Error: {e}")
            input("Press Enter to exit...")
        finally:
            self.cleanup()

def main():
    launcher = SimpleWebLauncher()
    launcher.run()

if __name__ == "__main__":
    main()
