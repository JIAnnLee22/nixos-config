{ inputs, pkgs, ... }:

{
  environment.systemPackages = [
    inputs.onmyoji.packages.${pkgs.system}.default
  ];
}
