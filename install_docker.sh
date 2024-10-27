#!/bin/bash

# 检查输入参数
if [ $# -gt 0 ]; then
    # 将传入的 IP 地址转换为数组
    IFS=',' read -r -a servers <<< "$1"
else
    # 如果没有传入参数，直接在本地安装
    install_docker_local
    exit 0  # 退出脚本，不执行后续服务器安装
fi

# 安装函数（适用于远程服务器）
install_docker() {
    local ip="$1"

    echo "正在安装 Docker 和 Docker Compose 在 $ip..."

    # 通过 SSH 连接到目标服务器执行安装，并实时打印到本地终端
    ssh -t -o StrictHostKeyChecking=no "ubuntu@$ip" << 'EOF'
        set -e  # 如果任何命令失败，退出脚本

        echo "开始安装 Docker 和 Docker Compose..."

        # 更新包信息并安装必要依赖
        echo "更新包信息..."
        sudo apt update -y && echo "包信息更新完成。" || { echo "包信息更新失败。" && exit 1; }

        echo "安装必要依赖..."
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common && echo "依赖安装完成。" || { echo "依赖安装失败。" && exit 1; }

        # 安装 Docker GPG 密钥并添加 Docker APT 源
        echo "添加 Docker GPG 密钥..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo "GPG 密钥添加成功。" || { echo "GPG 密钥添加失败。" && exit 1; }
        echo "添加 Docker APT 源..."
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && echo "APT 源添加成功。" || { echo "APT 源添加失败。" && exit 1; }

        # 更新 APT 软件包缓存并安装 Docker
        echo "更新 APT 软件包缓存..."
        sudo apt update -y && echo "APT 软件包缓存更新完成。" || { echo "APT 软件包缓存更新失败。" && exit 1; }
        echo "安装 Docker..."
        sudo apt install -y docker-ce docker-ce-cli containerd.io && echo "Docker 安装完成。" || { echo "Docker 安装失败。" && exit 1; }

        # 将当前用户加入 docker 组以便无 sudo 权限使用
        echo "将用户加入 docker 组..."
        sudo usermod -aG docker $USER && echo "用户成功加入 docker 组。" || { echo "用户加入 docker 组失败。" && exit 1; }

        # 下载并安装 Docker Compose
        echo "下载 Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && echo "Docker Compose 下载成功。" || { echo "Docker Compose 下载失败。" && exit 1; }
        echo "赋予 Docker Compose 执行权限..."
        sudo chmod +x /usr/local/bin/docker-compose && echo "权限赋予成功。" || { echo "权限赋予失败。" && exit 1; }

        # 验证 Docker 和 Docker Compose 是否安装成功
        echo "验证 Docker 和 Docker Compose 是否安装成功..."
        docker --version
        docker-compose --version

        echo "Docker 和 Docker Compose 安装完成。无 sudo 权限即可使用 Docker Compose。"
EOF
}

# 安装函数（适用于本地）
install_docker_local() {
    echo "正在安装 Docker 和 Docker Compose 在本地..."

    set -e  # 如果任何命令失败，退出脚本

    echo "开始安装 Docker 和 Docker Compose..."

    # 更新包信息并安装必要依赖
    echo "更新包信息..."
    sudo apt update -y && echo "包信息更新完成。" || { echo "包信息更新失败。" && exit 1; }

    echo "安装必要依赖..."
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common && echo "依赖安装完成。" || { echo "依赖安装失败。" && exit 1; }

    # 安装 Docker GPG 密钥并添加 Docker APT 源
    echo "添加 Docker GPG 密钥..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && echo "GPG 密钥添加成功。" || { echo "GPG 密钥添加失败。" && exit 1; }
    echo "添加 Docker APT 源..."
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && echo "APT 源添加成功。" || { echo "APT 源添加失败。" && exit 1; }

    # 更新 APT 软件包缓存并安装 Docker
    echo "更新 APT 软件包缓存..."
    sudo apt update -y && echo "APT 软件包缓存更新完成。" || { echo "APT 软件包缓存更新失败。" && exit 1; }
    echo "安装 Docker..."
    sudo apt install -y docker-ce docker-ce-cli containerd.io && echo "Docker 安装完成。" || { echo "Docker 安装失败。" && exit 1; }

    # 将当前用户加入 docker 组以便无 sudo 权限使用
    echo "将用户加入 docker 组..."
    sudo usermod -aG docker $USER && echo "用户成功加入 docker 组。" || { echo "用户加入 docker 组失败。" && exit 1; }

    # 下载并安装 Docker Compose
    echo "下载 Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && echo "Docker Compose 下载成功。" || { echo "Docker Compose 下载失败。" && exit 1; }
    echo "赋予 Docker Compose 执行权限..."
    sudo chmod +x /usr/local/bin/docker-compose && echo "权限赋予成功。" || { echo "权限赋予失败。" && exit 1; }

    # 验证 Docker 和 Docker Compose 是否安装成功
    echo "验证 Docker 和 Docker Compose 是否安装成功..."
    docker --version
    docker-compose --version

    echo "Docker 和 Docker Compose 安装完成。无 sudo 权限即可使用 Docker Compose。"
}

# 循环处理每个服务器
for ip in "${servers[@]}"; do
    install_docker "$ip" &
done

# 等待所有后台进程完成
wait
