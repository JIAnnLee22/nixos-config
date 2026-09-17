# ~/.config/fcitx5/profile 会覆盖 NixOS 的 /etc/xdg/fcitx5/profile，因此把分组写在这里。
{ pkgs, ... }:
let
  ini = pkgs.formats.ini { };
  catppuccinTheme = pkgs.catppuccin-fcitx5.override { withRoundedCorners = true; };
  # tiger/tigress 的输入法描述使用 fcitx-tiger；上游没有提供这个图标。
  tigerIcon = pkgs.writeText "fcitx-tiger.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
      <rect width="64" height="64" rx="14" fill="#d08770"/>
      <path d="M10 23 16 9l10 9M54 23 48 9 38 18" fill="#c9b890" stroke="#201b14" stroke-width="4" stroke-linejoin="round"/>
      <path d="M15 25c0-10 8-16 17-16s17 6 17 16v15c0 10-8 17-17 17S15 50 15 40Z" fill="#c9b890" stroke="#201b14" stroke-width="4"/>
      <path d="M24 23h16M27 29h10M32 21v14M22 39l6 2m14-2-6 2" fill="none" stroke="#201b14" stroke-width="4" stroke-linecap="round"/>
      <path d="m28 45 4 3 4-3" fill="#201b14" stroke="#201b14" stroke-width="3" stroke-linejoin="round"/>
    </svg>
  '';
in
{
  xdg.configFile."fcitx5/profile".source = ini.generate "fcitx5-profile" {
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "us";
      DefaultIM = "flypy";
    };
    "Groups/0/Items/0" = {
      Name = "keyboard-us";
      Layout = "";
    };
    "Groups/0/Items/1" = {
      Name = "flypy";
      Layout = "";
    };
    "Groups/0/Items/2" = {
      Name = "tigress";
      Layout = "";
    };
    GroupOrder."0" = "Default";
  };

  # 候选框跟随每块输出的 DPI；浅色使用 Latte，深色默认使用 Mocha。
  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Vertical Candidate List=False
    WheelForPaging=True
    Font=monospace 14
    MenuFont=monospace 14
    TrayFont=monospace Bold 12
    TrayOutlineColor=#201b14
    TrayTextColor=#e8e1d4
    PreferTextIcon=False
    ShowLayoutNameInIcon=True
    UseInputMethodLanguageToDisplayText=True
    Theme=catppuccin-latte-mauve
    DarkTheme=catppuccin-mocha-mauve
    UseDarkTheme=True
    UseAccentColor=False
    PerScreenDPI=True
  '';

  # 安装 Catppuccin 的四种官方风味；统一使用 Mauve 强调色和上游圆角资源。
  xdg.dataFile."fcitx5/themes/catppuccin-latte-mauve".source =
    "${catppuccinTheme}/share/fcitx5/themes/catppuccin-latte-mauve";
  xdg.dataFile."fcitx5/themes/catppuccin-frappe-mauve".source =
    "${catppuccinTheme}/share/fcitx5/themes/catppuccin-frappe-mauve";
  xdg.dataFile."fcitx5/themes/catppuccin-macchiato-mauve".source =
    "${catppuccinTheme}/share/fcitx5/themes/catppuccin-macchiato-mauve";
  xdg.dataFile."fcitx5/themes/catppuccin-mocha-mauve".source =
    "${catppuccinTheme}/share/fcitx5/themes/catppuccin-mocha-mauve";

  xdg.dataFile."icons/hicolor/scalable/apps/fcitx-tiger.svg".source = tigerIcon;
  xdg.dataFile."icons/hicolor/scalable/apps/org.fcitx.Fcitx5.fcitx-tiger.svg".source = tigerIcon;
}
