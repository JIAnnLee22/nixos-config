{ ... }:

{
  home = {
    username = "jiannlee22";
    homeDirectory = "/home/jiannlee22";
    stateVersion = "25.11";
  };

  imports = [
    ./foot.nix
    ./nvim
  ];

  programs.git.enable = true;
}
