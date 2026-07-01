{ pkgs, ... }:

{
  home.packages = [ pkgs.yazi pkgs.ouch pkgs.yaziPlugins.ouch ];

  # 链接 ouch.yazi 插件到 yazi 插件目录
  xdg.configFile."yazi/plugins/ouch.yazi".source = "${pkgs.yaziPlugins.ouch}";

  xdg.configFile."yazi/yazi.toml".source = ./yazi/yazi.toml;
  xdg.configFile."yazi/keymap.toml".source = ./yazi/keymap.toml;
  xdg.configFile."yazi/theme.toml".source = ./yazi/theme.toml;
}
