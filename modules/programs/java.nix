# JDK 环境配置
{ pkgs, ... }:

{
  # 系统默认 JDK
  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };

  # programs.java 会把默认 JDK 放入系统 PATH，避免多个 JDK 的 java 命令发生冲突。
  # 其他版本通过 Home Manager 的 ~/.jdks 链接供 IDE 选择。
}
