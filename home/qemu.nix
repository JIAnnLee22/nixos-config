{ ... }:

{
  home = {
    username = "jiannlee22";
    homeDirectory = "/home/jiannlee22";
    stateVersion = "25.11";
  };

  imports = [
    ../modules/nvim
  ];

  programs.git.enable = true;
}
