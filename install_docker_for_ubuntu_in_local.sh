#!/bin/bash

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <ip1,ip2,ip3,...>"
    exit 1
fi

# 将传入的 IP 地址字符串分割成数组
IFS=',' read -r -a SERVERS <<< "$1"

# 安装函数
install_docker() {
    local SERVER="$1"
    echo "----- 正在安装 $SERVER -----"

    # 通过 SSH 执行安装脚本
    if ssh -o StrictHostKeyChecking=no "$SERVER" << 'EOF'
        bash <(curl -s https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker.sh)
EOF
    then
        echo "----- $SERVER 的安装完成 -----"
    else
        echo "----- $SERVER 的安装失败 -----"
    fi
}

# 遍历每台服务器执行安装
for SERVER in "${SERVERS[@]}"; do
    install_docker "$SERVER" &
done

# 等待所有后台进程完成
wait

echo "所有服务器的 Docker 和 Docker Compose 安装已完成，无需重新登录即可使用。"
