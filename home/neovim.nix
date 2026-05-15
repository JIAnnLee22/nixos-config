{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig =  ''
        set number
        set number relativenumber
        set cc=120
    '';
  };
}

