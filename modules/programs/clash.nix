{ ... }:
{
  programs.clash-verge = {
    enable = true;
    serviceMode = true;
    autoStart = true;
    tunMode = true;
    group = "wheel";
  };
}
