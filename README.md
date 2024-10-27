# install_docker_compose_for_ubuntu
一键安装docke compose 


根据你提供的 GitHub 仓库地址，修改后的命令应该如下所示：

## 一、本机安装
在Ubuntu 本机下安装Docker-compose,可以执行脚本

1. **使用 `curl` 执行脚本**：
   ```bash
   bash <(curl -s https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker.sh)
   ```

2. **使用 `wget` 执行脚本**：
   ```bash
   sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker.sh)"
   
   ```
   

## 二、远程服务器安装
对多个远程 Ubuntu 服务器安装Docker-compose，可以执行脚本

1. **使用 `curl` 执行脚本**：

   ```bash
   
   bash <(curl -s https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker_for_ubuntu_in_local.sh <ip1,ip2,ip3,...>)
   
   ```

2. **使用 `wget` 执行脚本** :

   ```bash
   
   sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker_for_ubuntu_in_local.sh <ip1,ip2,ip3,...>)"
   
   ```


