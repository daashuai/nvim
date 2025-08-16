import os
import socket

def debugger_config(debug=False):
    # 直接获取可用端口（不读取现有环境变量）
    # with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    #     s.bind(("localhost", 0))  # 系统自动分配可用端口
    #     available_port = s.getsockname()[1]  # 提取分配的端口号
    #     os.environ["DEBUG_PORT"] = str(available_port)  # 仅写入环境变量


    available_port = 5678
    os.environ["DEBUG_PORT"] = str(available_port)
    # 调试开关逻辑
    debug_enabled = os.environ.get("DEBUG") == "1"
    if debug_enabled or debug:
        import debugpy
        print(f"Waiting for debugger attach on port {available_port}...")
        debugpy.listen(("localhost", available_port))
        debugpy.wait_for_client()
        print("Debugger attached!")

