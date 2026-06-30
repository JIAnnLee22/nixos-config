# 字体配置
{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      fira-code
      maple-mono.NF-CN
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK SC"
        ];
        serif = [
          "Noto Serif CJK SC"
        ];
        monospace = [
          "Fira Code"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
