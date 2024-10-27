# install_docker_compose_for_ubuntu
一键安装docke compose 


根据你提供的 GitHub 仓库地址，修改后的命令应该如下所示：

1. **使用 `curl` 执行脚本**：
   ```bash
   bash <(curl -s https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker.sh)
   ```

2. **使用 `wget` 执行脚本**：
   ```bash
   sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker.sh)"
   
   ```


2. **用curl执行脚本**：
   - 为远程多台服务器安装：
   
```bash
   
   bash <(curl -s https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker_for_ubuntu_in_local.sh) "127.0.0.1,10.56.65.122"

```

- 为在指定 IP 地址的服务器上安装（如在 `127.0.0.1` 和 `10.56.65.122` 上）：
     
```bash
   sudo bash -c "$(wget -qO - https://raw.githubusercontent.com/SaudM/install_docker_compose_for_ubuntu/main/install_docker_for_ubuntu_in_local.sh)" "127.0.0.1,10.56.65.122"
 
```
     

### 注意事项

- 确保你的 SSH 密钥已添加到目标服务器，并且你可以无需密码登录。
- 此脚本假定你使用 `ubuntu` 用户进行 SSH 连接。如果你的用户不同，请相应地修改脚本中的用户。
- 为了安全起见，可以添加 SSH 密钥和用户验证的更复杂的检查。