{ config, lib, ... }:
let
  # mango 配置文件统一放在 dotfile 仓库的 mango/ 目录，用 store 外软链接方式管理
  # （与 mangobar 不同：目录级 mkOutOfStoreSymlink 会被 linkfarm 递归枚举导致
  #  "outside $HOME" 构建失败，故逐文件链接）
  mangoDir = "${config.home.homeDirectory}/nixos-config/dotfile/mango";
  files = [
    "config.conf"
    "bindings.conf"
    "env.conf"
    "rule.conf"
    "autostart.conf"
    "lock.sh"
    "wlogout/layout"
    "wlogout/style.css"
  ];
in
{
  xdg.configFile = builtins.listToAttrs (map (f: {
    name = "mango/${f}";
    value = {
      source = config.lib.file.mkOutOfStoreSymlink "${mangoDir}/${f}";
    };
  }) files);
}
