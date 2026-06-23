# 环境变量和 PATH 配置
{ config, pkgs, ... }:

{
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";
    OBSFILE_ROOT = "${config.home.homeDirectory}/obs";
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
    PI_CODING_AGENT_SESSION_DIR = "${config.xdg.dataHome}/pi/sessions";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    # 图形化 sudo 密码输入
    SUDO_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/ssh-askpass";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/go/bin"
    "${config.home.homeDirectory}/obs/obsgen/linux"
    "${config.home.homeDirectory}/.npm-global/bin"
  ];
}
