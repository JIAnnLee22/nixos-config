{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
    extraConfig =  ''
        set number
        set number relativenumber
        set cc=120
    '';
  };
}

