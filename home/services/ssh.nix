# SSH 配置
# 使用 activation script 管理，因为 SSH 严格要求 ~/.ssh/config 权限为 600
# nix store 中的符号链接权限为 777 会导致 "Bad owner or permissions" 错误
{ config, ... }:

let
  sshConfigPath = "${config.home.homeDirectory}/.ssh/config";

  # ========== 在这里编辑 SSH 配置 ==========
  sshConfigContent = ''
    # GitHub (使用 443 端口避免代理问题)
    Host github.com
      HostName ssh.github.com
      Port 443
      User git
      IdentityFile ~/.ssh/id_ed25519

    # 添加更多 Host 配置...
    # Host myserver
    #   HostName 192.168.1.100
    #   User admin
    #   IdentityFile ~/.ssh/id_ed25519
  '';
  # ========================================
in
{
  home.activation.sshConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$(dirname "${sshConfigPath}")"
    cat > "${sshConfigPath}" << 'SSHEOF'
${sshConfigContent}
SSHEOF
    chmod 600 "${sshConfigPath}"
  '';
}
