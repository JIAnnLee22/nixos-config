{
  home.username = "jiannlee22";
  home.homeDirectory = "/home/jiannlee22";
  home.stateVersion = "25.11";

  imports = [
    ./mango/config.nix
    ./mango/autostart.nix
    ./mango/bindings.nix
    ./mango/env.nix
    ./mango/rule.nix
    ./mango/layout.nix
  ];
}
