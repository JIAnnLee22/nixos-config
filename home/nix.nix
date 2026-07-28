{ lib, pkgs, ... }:

{
  # Keep `nix shell`, `nix run`, and legacy `nix-shell -p` on the same
  # cache policy even when this Home Manager configuration is used standalone.
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = import ../modules/nix-cache-settings.nix;
  };
}
