#!/bin/bash

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <ip1,ip2,ip3,...>"
    exit 1
fi

# 将传入的 IP 地址字符串分割成数组
IFS=',' read -r -a SERVERS <<< "$1"

# 遍历每台服务器执行安装
for SERVER in "${SERVERS[@]}"; do
    echo "----- 正在安装 $SERVER -----"

    ssh "$SERVER" << 'EOF'
        # 更新包信息并安装必要依赖
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

        # 安装 Docker GPG 密钥并添加 Docker APT 源
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # 更新 APT 软件包缓存并安装 Docker
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io

        # 将当前用户加入 docker 组以便无 sudo 权限使用
        sudo usermod -aG docker $USER

        # 下载并安装 Docker Compose
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose

        # 立即生效 Docker 组更改，无需重新登录
        newgrp docker <<EOF2
            # 验证 Docker 和 Docker Compose 是否安装成功
            docker --version
            docker-compose --version
EOF2

EOF

    echo "----- $SERVER 的安装完成 -----"
done

echo "所有服务器的 Docker 和 Docker Compose 安装已完成，无需重新登录即可使用。"
