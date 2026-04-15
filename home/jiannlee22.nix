{
  home.username = "jiannlee22";
  home.homeDirectory = "/home/jiannlee22";
  home.stateVersion = "25.11";

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
    ./mango/config.nix
    ./mango/autostart.nix
    ./mango/bindings.nix
    ./mango/env.nix
    ./mango/rule.nix
    ./mango/layout.nix
  ];
}
