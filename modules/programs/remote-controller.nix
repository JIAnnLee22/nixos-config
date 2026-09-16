{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wayvnc
    wlr-randr
    tigervnc
  ];
}

