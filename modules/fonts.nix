# 字体配置
{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      fira-code
      maple-mono.NF-CN
    ];

    fontconfig = {
      antialias = true;
      hinting = {
        enable = true;
        # 比默认 slight 更贴合像素网格，低/中 DPI 屏幕会更清晰。
        style = "medium";
      };
      subpixel = {
        # 大多数横向 LCD/OLED 屏幕都是 RGB 子像素排列；开启后边缘更锐利。
        rgba = "rgb";
        lcdfilter = "default";
      };
      defaultFonts = {
        sansSerif = [
          "Inter"
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        serif = [
          "Noto Serif"
          "Noto Serif CJK SC"
        ];
        monospace = [
          "Maple Mono NF CN"
          "Fira Code"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
