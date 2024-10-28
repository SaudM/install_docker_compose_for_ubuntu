#!/bin/bash

# 更新包信息并安装必要依赖
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# 安装 Docker GPG 密钥并添加 Docker APT 源
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 更新 APT 软件包缓存并安装 Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

# 创建 Docker 组（如果尚未存在），并将当前用户添加到 docker 组
sudo groupadd -f docker
sudo usermod -aG docker ubuntu

# 下载并安装 Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 刷新组变更并验证 Docker 和 Docker Compose 安装
newgrp docker <<EOF
    docker --version && echo "Docker 安装成功"
    docker-compose --version && echo "Docker Compose 安装成功"
    docker ps && echo "无 sudo 权限运行 docker ps 成功"
EOF

echo "Docker 和 Docker Compose 安装完成，无需 sudo 权限即可使用 Docker。"
