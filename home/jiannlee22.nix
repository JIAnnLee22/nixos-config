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
  };
  home.sessionPath = [ "${config.home.homeDirectory}/go/bin" ];

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

  imports = [
    ./fcitx5-profile.nix
    ./mango/config.nix
    ./mango/autostart.nix
    ./mango/bindings.nix
    ./mango/env.nix
    ./mango/rule.nix
    ./mango/layout.nix
    ./foot.nix
    ./neovim.nix
  ];
}
