# Pi Coding Agent：二进制由 Nix 提供；可变配置和扩展包保留在 ~/dotfile/pi。
{ config, lib, pkgs, ... }:

let
  dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
  pi = pkgs."pi-coding-agent";
  node = pkgs.nodejs_24;
  piConfigDir = "${dotfile}/pi";
  piConfigLink = "${config.xdg.configHome}/pi";
in
{
  home.packages = [ pi ];

  # Put the store-backed executable before legacy npm-global binaries in PATH.
  home.sessionPath = [ "${pi}/bin" ];
  # Pi 0.85.1 reads its agent configuration from PI_CODING_AGENT_DIR. Keep this
  # pointed at the XDG link below, whose real target is the dotfile submodule.
  home.sessionVariables = {
    PI_CODING_AGENT_DIR = piConfigLink;
    PI_PACKAGE_DIR = "${piConfigLink}/npm";
  };

  # Keep the editable, version-controlled Pi configuration outside the Nix store.
  # The resulting ~/.config/pi link resolves to ~/nixos-config/dotfile/pi.
  xdg.configFile."pi" = {
    source = config.lib.file.mkOutOfStoreSymlink piConfigDir;
    force = true;
  };

  # Pi extensions are user-state by design.  Install the pinned extension set on
  # first Home Manager activation, without managing auth.json or session data.
  home.activation.installPiExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${node}/bin:$PATH"
    export PI_CODING_AGENT_DIR=${lib.escapeShellArg piConfigLink}
    export PI_PACKAGE_DIR="$PI_CODING_AGENT_DIR/npm"

    if [ ! -f "$PI_CODING_AGENT_DIR/settings.json" ]; then
      echo "Pi configuration is missing: $PI_CODING_AGENT_DIR/settings.json" >&2
      exit 1
    fi

    ensure_pi_extension() {
      local source="$1" package="$2" expected_version="$3"
      local manifest="$PI_CODING_AGENT_DIR/npm/node_modules/$package/package.json"
      local installed_version=""

      if [ -f "$manifest" ]; then
        installed_version="$(${node}/bin/node -e 'process.stdout.write(require(process.argv[1]).version)' "$manifest" 2>/dev/null || true)"
      fi

      if [ "$installed_version" != "$expected_version" ]; then
        ${pi}/bin/pi install "$source"
      fi
    }

    ensure_pi_extension "npm:@ff-labs/pi-fff@0.10.6" "@ff-labs/pi-fff" "0.10.6"
    ensure_pi_extension "npm:pi-web-access@0.28.0" "pi-web-access" "0.28.0"
    ensure_pi_extension "npm:context-mode@1.0.169" "context-mode" "1.0.169"
  '';
}
