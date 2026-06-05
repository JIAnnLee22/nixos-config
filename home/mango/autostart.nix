{ mangoWallpaperPath, ... }:
{
  xdg.configFile."mango/autostart.conf".text = ''
    exec-once=swaybg -i ${mangoWallpaperPath} -m fill &
    exec-once=waybar &
    exec-once=mako &
    exec-once=fcitx5 --replace -d >/dev/null 2>&1 &
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
    exec-once=wl-clip-persist --clipboard regular --reconnect-tries 0 &
    exec-once=wl-paste --type text --watch cliphist store &
  '';
}
