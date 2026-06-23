# Android Studio Gradle JDK 选择列表
# 通过在 ~/.jdks/ 下创建符号链接，让 Android Studio 自动发现 NixOS 中的 JDK
{ pkgs, ... }:

{
  home.file = {
    ".jdks/openjdk-11" = { source = "${pkgs.jdk11.home}"; };
    ".jdks/openjdk-17" = { source = "${pkgs.jdk17.home}"; };
  };
}
