# clashtui 用户模式配置（Home Manager）——适配 clashtui 0.3.x
#
# 对应官方安装脚本：bash <(curl ...installs/install) --core mihomo --is-user
# （0.3.0 起配置 schema 与目录结构相对 0.2 不兼容，本文件按 0.3.1 实现。）
#
# 目录布局（与官方 install 脚本一致）：
#   ~/.local/clashtui/mihomo/mihomo        → 软链接到 /run/wrappers/bin/mihomo（带 cap）
#   ~/.local/clashtui/mihomo/config/       → mihomo 运行目录
#       config.yaml                        → 初始即写入 core_override 内容（含
#                                            external-controller: 9090），故 mihomo
#                                            首次启动 9090 即上线，避免 0.2.3 那种
#                                            “空 stub 配置 → 9090 不监听 → 热重载
#                                            connection refused”的竞态。
#   ~/.config/clashtui/config.yaml         → clashtui TUI 主配置（0.3 schema：
#                                            mihomo.core / core_service / singbox / ...）
#   ~/.config/clashtui/mihomo/core_override_config.yaml
#                                        → mihomo 核心覆盖模板（TUN+DNS 已开启），
#                                          切换订阅时 clashtui 以此为基线合并 profile，
#                                          再写入 ~/.local/clashtui/mihomo/config/config.yaml。
#   ~/.config/clashtui/mihomo/template_proxy_providers.yaml
#                                        → 订阅 URL（分组 YAML 格式，0.3 恢复分组）。
#   ~/.config/clashtui/mihomo/{profiles,templates}/
#   ~/.config/clashtui/sing-box/...       → sing-box 相关目录（clashtui init 会补齐）。
#
# TUN：用户态 systemd 服务无 root，靠 modules/services/clashtui.nix 中的
#      security.wrappers.mihomo（setcap cap_net_admin,...）提供能力，
#      故即便 --is-user，本文件仍启用 TUN（官方 install 脚本在 --is-user 时
#      默认关闭 TUN，是因为普通用户无 cap；我们有 wrapper，不受此限）。
#
# 路径：clashtui 用 std::path::absolute 解析 config.yaml 中的路径，不展开 `~`，
#       故 config_dir / bin_path / config_path 一律用绝对路径。
#
# 使用流程：
#   1. home-manager switch 后，本模块已写好 config.yaml / core_override_config.yaml，
#      并在运行时目录放入初始 config.yaml（9090 已可用）。
#   2. 编辑 ~/.config/clashtui/mihomo/template_proxy_providers.yaml 填入机场订阅 URL。
#   3. 在 clashtui 的 Files 标签页用模板生成 profile（或 `i` 导入订阅），
#      `a` 更新资源，回车选择 profile → clashtui 合并 core_override + profile，
#      写入 ~/.local/clashtui/mihomo/config/config.yaml 并经 9090 API 热重载。

{ pkgs, lib, config, ... }:

let
  # 带文件 capabilities 的 mihomo wrapper（由 NixOS security.wrappers 生成）
  mihomoWrapper = "/run/wrappers/bin/mihomo";

  # installation paths (must remain identical to user-mode install script)
  homeDir        = config.home.homeDirectory;
  installDir     = "${homeDir}/.local/clashtui";
  mihomoDir      = "${installDir}/mihomo";
  mihomoBin      = "${mihomoDir}/mihomo";        # 软链接 → wrapper
  mihomoCfgDir   = "${mihomoDir}/config";        # mihomo 运行目录（-d）
  mihomoCfgFile  = "${mihomoCfgDir}/config.yaml";# mihomo 运行配置（-f 隐式）

  # clashtui TUI 配置目录（~/.config/clashtui）
  tuiDir        = "${homeDir}/.config/clashtui";
  mihomoTuiDir  = "${tuiDir}/mihomo";
in
{
  # ── 用户态 systemd 服务：clashtui_mihomo ─────────────────────────────────────
  # 服务名与 config.yaml 中 mihomo.core_service.service_name 一致；
  # is_user: true 时 clashtui 执行 systemctl --user restart clashtui_mihomo。
  # ExecStart 指向带 cap 的 wrapper，故用户态也能开 TUN。
  systemd.user.services.clashtui_mihomo = {
    Unit = {
      Description = "mihomo Daemon, Another Clash Kernel.";
      Documentation = [ "https://wiki.metacubex.one" ];
      After = [ "network.target" ];
    };
    Service = {
      Type         = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1s";
      ExecStart    = "${mihomoWrapper} -d ${mihomoCfgDir}";
      ExecReload   = "${pkgs.procps}/bin/kill -HUP $MAINPID";
      Restart      = "always";
      RestartSec   = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # ── 一次性初始化：目录结构 + 写入 clashtui 所需配置文件 ───────────────────────
  # 用 activation 而非 home.file：clashtui 会把 config.yaml / core_override_config.yaml
  # 等当作普通文件读写，若用 home.file 会在 switch 时报 "Existing file is in the way"。
  # 这两个由 Nix 完全托管；运行时 config.yaml 仅在缺失时 bootstrap（之后由 clashtui 管理）。
  home.activation.clashtui = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # 目录结构：与 install script 一致
    run mkdir -p $VERBOSE_ARG \
      ${mihomoDir} \
      ${mihomoCfgDir} \
      ${mihomoTuiDir}/profiles \
      ${mihomoTuiDir}/templates

    # mihomo 二进制软链接 → 带 cap 的 wrapper（每次 switch 刷新指向最新 wrapper）
    run $DRY_RUN_CMD ln -sfn ${mihomoWrapper} ${mihomoBin}

    # ── clashtui 主配置 config.yaml（0.3 schema：mihomo/singbox/timeout/extra） ─
    # 路径必须为绝对路径（clashtui 用 std::path::absolute 解析，不展开 ~）。
    # sing-box 段保留默认占位（本机用 mihomo）；clashtui init 会补齐 sing-box 目录。
    run $DRY_RUN_CMD cat > ${tuiDir}/config.yaml << 'EOF'
mihomo:
  core:
    config_dir: ${mihomoCfgDir}
    bin_path: ${mihomoBin}
    config_path: ${mihomoCfgFile}
  core_service:
    service_name: clashtui_mihomo
    is_user: true
singbox:
  core:
    bin_path: ${homeDir}/.local/clashtui/sing-box/sing-box
    config_dir: ${homeDir}/.local/clashtui/sing-box/config
    config_path: ${homeDir}/.local/clashtui/sing-box/config/config.json
  core_service:
    service_name: clashtui_singbox
    is_user: true
timeout:
extra:
  edit_cmd:
  open_dir_cmd:
EOF

    # ── mihomo 核心覆盖模板（~/.config/clashtui/mihomo/core_override_config.yaml） ─
    # clashtui 生成最终 mihomo 配置时，顶层字段以此文件覆盖订阅内容。
    # 采用官方 contrib/default_configs/mihomo/core_override_config.yaml：
    # TUN 与 DNS 均已开启，配合 wrapper 的 cap_net_admin 即可实现透明代理。
    # （官方 install 在 --is-user 时用 no_tun 版本；我们有 cap wrapper，故用 TUN 版。）
    run $DRY_RUN_CMD cat > ${mihomoTuiDir}/core_override_config.yaml << 'EOF'
# Arbitrary configuration, for reference only.
# 顶层字段会在切换订阅时覆盖订阅配置的对应字段。
mixed-port: 7890
ipv6: false
allow-lan: false
log-level: silent
unified-delay: true
tcp-concurrent: true

secret: ""
external-controller: 127.0.0.1:9090
external-ui: uis/metacubexd
external-ui-url: https://github.com/MetaCubeX/metacubexd/archive/refs/heads/gh-pages.zip

geo-auto-update: true
geo-update-interval: 7

profile:
  store-selected: true
  store-fake-ip: true

sniffer:
  enable: true
  sniff:
    HTTP:
      ports: [80, 8080-8880]
      override-destination: true
    TLS:
      ports: [443, 8443]
    QUIC:
      ports: [443, 8443]
  skip-domain:
    - "Mijia Cloud"
    - "+.push.apple.com"

tun:
  enable: true
  stack: mixed
  dns-hijack:
    - "any:53"
    - "tcp://any:53"
  auto-route: true
  auto-redirect: true
  auto-detect-interface: true

dns:
  enable: true
  ipv6: true
  enhanced-mode: fake-ip
  fake-ip-filter:
    - "*"
    - "+.lan"
    - "+.local"
    - "+.market.xiaomi.com"
    - "auth-6441.wifi.com"
  default-nameserver:
    - tls://223.5.5.5
    - tls://223.6.6.6
  nameserver:
    - https://doh.pub/dns-query
    - https://dns.alidns.com/dns-query
  nameserver-policy:
    "auth-6441.wifi.com": "system://"       # use system DNS resolver
EOF

    # ── 运行时初始 config.yaml（仅缺失时 bootstrap） ───────────────────────────
    # 与官方 install 一致：把 core_override 内容复制到 mihomo 运行目录作为初始
    # config.yaml。这样 mihomo 首次启动即带 external-controller: 9090，
    # clashtui 的热重载 API 可用；之后用户选择 profile 时 clashtui 会覆写此文件。
    if [ ! -f ${mihomoCfgFile} ]; then
      run $DRY_RUN_CMD cp ${mihomoTuiDir}/core_override_config.yaml ${mihomoCfgFile}
    fi

    # ── 订阅 URL 配置（首次创建，用户自行填入机场订阅链接） ─────────────────────
    # 0.3 恢复分组 YAML 格式（与 0.2.3 的纯文本不同）。
    if [ ! -f ${mihomoTuiDir}/template_proxy_providers.yaml ]; then
      run $DRY_RUN_CMD cat > ${mihomoTuiDir}/template_proxy_providers.yaml << 'EOF'
# Define proxy-provider subscription URLs here, organized by group.
# In templates use ''${PPG.<group>} to reference all providers in a group,
# or ''${PPG.<group>.<provider>} for a specific one.
#
# Format:
#   <group-name>:
#     <provider-name>: "<subscription-url>"
#
# Clashtui's built-in templates only use the group level
# (e.g. ''${PPG.pvd}, not ''${PPG.pvd.pvd0}). Provider names
# (pvd0, pvd1, ...) are freely defined by the user.
#
# Example (following clashtui convention):
#   pvd:
#     pvd0: "https://example.com/sub1.yaml"
#     pvd1: "https://example.com/sub2.yaml"
EOF
    fi

    # 已存在运行时 config.yaml 时 enable --now（首次 switch 因刚 bootstrap 也满足）。
    # 用绝对路径调用 systemctl（activation 环境 PATH 极简）；首次安装时
    # Home Manager 的 reloadSystemd 已负责拉起服务，此处仅为后续 switch 保险。
    if [[ ! -v DRY_RUN ]]; then
      run ${pkgs.systemd}/bin/systemctl --user daemon-reload || true
      if [ -f ${mihomoCfgFile} ]; then
        run ${pkgs.systemd}/bin/systemctl --user enable --now clashtui_mihomo || true
      fi
    fi
  '';
}
