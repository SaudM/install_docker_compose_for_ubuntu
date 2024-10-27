#!/bin/bash

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <ip1,ip2,ip3,...>"
    exit 1
fi

# 分割 IP 地址字符串成数组
IFS=',' read -r -a SERVERS <<< "$1"

# 定义安装脚本 URL 和日志路径
INSTALL_SCRIPT_URL="https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker.sh"
LOG_FILE="install_docker_$(date +'%Y%m%d%H%M%S').log"

# 安装函数
install_docker() {
    local SERVER="$1"
    echo "----- 正在安装 Docker 和 Docker Compose 到 $SERVER -----" | tee -a "$LOG_FILE"

    # 使用 ssh 公钥认证进行安装
    if ssh -t "ubuntu@$SERVER" << EOF >> "$LOG_FILE" 2>&1
        sudo bash -c "$(wget -qO - $INSTALL_SCRIPT_URL)"
EOF
    then
        echo "----- $SERVER 的安装完成 -----" | tee -a "$LOG_FILE"
    else
        echo "----- $SERVER 的安装失败 -----" | tee -a "$LOG_FILE"
    fi
}

# 控制并发数（最多3个同时运行）
MAX_JOBS=3
for SERVER in "${SERVERS[@]}"; do
    ((i=i%MAX_JOBS)); ((i++==0)) && wait
    install_docker "$SERVER" &
done

wait
echo "所有服务器的 Docker 和 Docker Compose 安装已完成，无需重新登录即可使用。" | tee -a "$LOG_FILE"
