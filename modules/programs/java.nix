# JDK 环境配置
{ pkgs, ... }:

{
  # 系统默认 JDK
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  # 提供多个 JDK 版本供选择
  environment.systemPackages = with pkgs; [
    jdk11
    jdk17
  ];
}
