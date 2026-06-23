{ config, pkgs, ... }:

{
  home.username = "jiannlee22";
  home.homeDirectory = "/home/jiannlee22";
  home.stateVersion = "25.11";

  home.pointerCursor = {
    package = pkgs.oreo-cursors-plus;
    name = "oreo_white_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Expose binaries from `go install` (default layout: GOPATH/go + bin under ~/go/bin).
  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
    GOBIN = "${config.home.homeDirectory}/go/bin";
    OBSFILE_ROOT = "${config.home.homeDirectory}/obs";
    PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
    PI_CODING_AGENT_SESSION_DIR = "${config.xdg.dataHome}/pi/sessions";
    NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    # 图形化 sudo 密码输入
    SUDO_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/ssh-askpass";
  };
  home.sessionPath = [ 
  "${config.home.homeDirectory}/go/bin"
  "${config.home.homeDirectory}/obs/obsgen/linux"
  "${config.home.homeDirectory}/.npm-global/bin"
  ];

  # Interactive non-login bash only reads ~/.bashrc; without it, hm-session-vars.sh
  # (PATH, GOBIN, GOPATH from Home Manager) is never sourced — `go install` tools stay missing.
  programs.bash = {
    enable = true;
    profileExtra = ''
      export PATH="$PATH:${config.home.homeDirectory}/.local/share/JetBrains/Toolbox/scripts"
    '';
    # HM only puts hm-session-vars in ~/.profile; Kitty (and most terminals) start a
    # non-login bash, which never reads ~/.profile — only this block runs (after $- check).
    initExtra = ''
      if [[ -r "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]]; then
        . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };

  # SSH 配置
  # 使用 activation script 管理，因为 SSH 严格要求 ~/.ssh/config 权限为 600
  # nix store 中的符号链接权限为 777 会导致 "Bad owner or permissions" 错误
  # 修改此配置后运行 home-manager switch 生效
  home.activation.sshConfig = let
    sshConfigPath = "${config.home.homeDirectory}/.ssh/config";
    # ========== 在这里编辑 SSH 配置 ==========
    sshConfigContent = ''
      # GitHub (使用 443 端口避免 daed/dae 代理问题)
      Host github.com
        HostName ssh.github.com
        Port 443
        User git
        IdentityFile ~/.ssh/id_ed25519

      # 添加更多 Host 配置...
      # Host myserver
      #   HostName 192.168.1.100
      #   User admin
      #   IdentityFile ~/.ssh/id_ed25519
    '';
    # ========================================
  in config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$(dirname "${sshConfigPath}")"
    cat > "${sshConfigPath}" << 'SSHEOF'
${sshConfigContent}
SSHEOF
    chmod 600 "${sshConfigPath}"
  '';

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "inode/directory" = [ "pcmanfm.desktop" ];
      "application/x-directory" = [ "pcmanfm.desktop" ];
      "x-directory/normal" = [ "pcmanfm.desktop" ];
      "x-scheme-handler/file" = [ "pcmanfm.desktop" ];
    };
    defaultApplications = {
      "inode/directory" = [ "pcmanfm.desktop" ];
      "application/x-directory" = [ "pcmanfm.desktop" ];
      "x-directory/normal" = [ "pcmanfm.desktop" ];
      "x-scheme-handler/file" = [ "pcmanfm.desktop" ];
      "text/html" = [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      "x-scheme-handler/about" = [ "google-chrome.desktop" ];
      "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
    };
  };

  # Override local desktop entry so OpenURI can match file:// handlers.
  xdg.desktopEntries.pcmanfm = {
    name = "PCMan File Manager";
    genericName = "File Manager";
    comment = "Browse the file system and manage files";
    exec = "pcmanfm %U";
    terminal = false;
    icon = "system-file-manager";
    categories = [ "System" "FileTools" "FileManager" ];
    mimeType = [
      "inode/directory"
      "application/x-directory"
      "x-directory/normal"
      "x-scheme-handler/file"
    ];
  };

  # Android Studio Gradle JDK 选择列表
  # 通过在 ~/.jdks/ 下创建符号链接，让 Android Studio 自动发现 NixOS 中的 JDK
  # 注意：不要设置 recursive = true，否则会复制整个目录而非创建符号链接
  home.file = {
    ".jdks/openjdk-11" = { source = "${pkgs.jdk11.home}"; };
    ".jdks/openjdk-17" = { source = "${pkgs.jdk17.home}"; };

  };

  imports = [
    ./fcitx5-profile.nix
    ./mango/config.nix
    ./mango/wallpaper.nix
    ./mango/autostart.nix
    ./mango/bindings.nix
    ./mango/env.nix
    ./mango/rule.nix
    ./foot.nix
    ./lsp-servers.nix
    ./waybar.nix
    ./mako.nix
  ];
}
