# swaylock 配置 - 使用壁纸作为锁屏背景（与 swaybg 同一张，见 dotfile/mango/wallpaper.png）
{ ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      image = "~/.config/mango/wallpaper.png";
      scaling = "fill";
      # 外观
      font = "Maple Mono NF CN";
      font-size = 24;
      color = "201b14ff";
      inside-color = "201b14ff";
      inside-clear-color = "201b14ff";
      inside-ver-color = "201b14ff";
      inside-wrong-color = "201b14ff";
      key-hl-color = "89aa61ff";
      line-color = "444444ff";
      ring-color = "444444ff";
      ring-clear-color = "c9b890ff";
      ring-ver-color = "516c93ff";
      ring-wrong-color = "ad401fff";
      separator-color = "201b14ff";
      text-color = "c9b890ff";
      text-clear-color = "c9b890ff";
      text-ver-color = "c9b890ff";
      text-wrong-color = "ad401fff";
      # 行为
      show-failed-attempts = true;
      daemonize = true;
    };
  };
}
