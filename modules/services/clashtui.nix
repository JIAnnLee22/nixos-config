# clashtui —— Mihomo (Clash.Meta) TUI 客户端（系统层支持）
#
# clashtui 采用用户模式（对应官方 ./installs/install --is-user）：
#   - 所有运行时数据与配置位于 ~/.local/clashtui/ 和 ~/.config/clashtui/
#   - systemd 服务在用户态运行（systemctl --user clashtui_mihomo）
#   - 详见 home/clashtui.nix 的完整配置
#
# 本模块提供系统层支撑：
#   1. 提供 clashtui 二进制（mihomo 由 wrapper 提供，见下）
#   2. 为 mihomo 创建带 capabilities 的 setcap wrapper
#      用户态 systemd 服务无 root，必须靠文件 capabilities 才能创建 TUN
#      网卡。wrapper 位于 /run/wrappers/bin/mihomo，任何用户执行都会获得
#      CAP_NET_ADMIN / CAP_NET_RAW / CAP_NET_BIND_SERVICE。
#   3. 启用 lingering，保证用户态 systemd 服务在登出后/开机时持续运行。

{ pkgs, ... }:

{
  # clashtui TUI 本体（mihomo 不放这里，改由 security.wrappers 提供带 cap 的版本）
  environment.systemPackages = [ pkgs.clashtui ];

  # 带文件 capabilities 的 mihomo wrapper。
  # clashtui 的 bin_path（~/.local/clashtui/mihomo/mihomo）与 systemd 服务的
  # ExecStart 都指向这个 wrapper，从而用户态进程也能开启 TUN。
  security.wrappers.mihomo = {
    source = "${pkgs.mihomo}/bin/mihomo";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
    # +ep = permitted + effective，NixOS 的 security-wrapper 会把它们提升到
    # Ambient set，使非特权用户执行时也能获得这些能力。
    capabilities = "cap_net_admin,cap_net_raw,cap_net_bind_service+ep";
  };

  # 启用 lingering：用户态 systemd 服务在用户登出后仍持续运行，
  # 这是 clashtui_mihomo.service 开机自启动生效的前提条件。
  users.users.jiannlee22.linger = true;
}
