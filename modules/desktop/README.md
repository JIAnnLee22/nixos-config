# 选择窗口管理器
在 `flake.nix` 对应主机（`dnwx` 或 `ser`）的 `modules` 列表中，只引用其中一个桌面模块：
```nix
./modules/desktop/common.nix
./modules/desktop/mango.nix # Mango / Wayland
# 或替换上一行为：./modules/desktop/dwm.nix # dwm / X11
```
默认仍为 Mango。两个模块各自导入上游模块，不需要再单独引用 `inputs.mango.nixosModules.mango` 或 `inputs.dwm.nixosModules.default`，也不要同时引用两个桌面模块。
- Mango：greetd、Mango、mangobar、mako、swaylock，保留 Wayland 输入法配置及微信/飞书包装器。
- dwm：你的 `git@github.com:JIAnnLee22/dwm.git`、greetd、Xorg、dunst、slock，使用 X11 输入法和原版微信/飞书。两个桌面统一使用 greetd：首次开机自动登录，退出窗口管理器后回到 tuigreet。
- dwm 的启动链为 `greetd → dwm-session → startx → Xorg + dwm`；tuigreet 的登录命令也使用同一个 `dwm-session`。启用 NixOS 的 `startx.generateScript`，显式选择系统 xinitrc/xserverrc；Xorg 使用 greetd 的 VT1 和 `-keeptty`，保持 rootless/logind 终端权限。退出时由系统 xinitrc 清理图形用户会话。不再启用 LightDM。
- dwm 的快捷键和布局来自上游 `config.def.h`；`~/.config/dwm/scripts` 链接到现有 `dotfile/dwm/scripts`，自启动脚本通过 NixOS Bash 执行现有 `dotfile/dwm/autostart.sh`。dwm 仓库优先按 `XDG_CONFIG_HOME` 查找脚本，保留旧 data/`.dwm` 路径兼容；Nix 包将 `/run/wrappers/bin` 放到 PATH 首位以正确调用 slock，无需本仓库再补丁 C 配置。
- 独立 `homeConfigurations.jiannlee22` 不关联 NixOS 桌面，仍默认使用 Mango 用户配置；在 NixOS 上切换桌面请使用系统重建（其集成 Home Manager 会自动跟随），不要再单独覆盖成 Mango 配置。
新增文件需先 `git add modules/desktop/dwm.nix modules/dwm/default.nix`（不要求提交），否则 Git flake 看不到这些文件。切换后先构建检查，再重建并重启，避免当前图形会话被中断：
```sh
sudo nixos-rebuild build --flake .#dnwx
sudo nixos-rebuild boot --flake .#dnwx
sudo reboot
```
`ser` 主机请将 `dnwx` 替换为 `ser`。首次获取 dwm input 需要能访问 GitHub 的 SSH 凭证。
更新 dwm 而不更新其他 inputs：
```sh
nix flake update dwm
```
