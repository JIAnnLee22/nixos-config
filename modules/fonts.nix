# 字体配置
{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      wqy_microhei
      maple-mono.NF-CN
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
          "WenQuanYi Micro Hei"
        ];
        serif = [
          "Noto Serif"
          "Liberation Serif"
          "Noto Serif CJK SC"
          "WenQuanYi Micro Hei"
        ];
        monospace = [
          "Fira Code"
          "Noto Sans Mono CJK SC"
          "WenQuanYi Micro Hei"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
