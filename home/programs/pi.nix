# Pi Coding Agent：二进制由 Nix 提供；完整配置和运行时状态统一放在 dotfile/pi。
{ config, lib, pkgs, ... }:

let
  dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
  pi = pkgs."pi-coding-agent";
  node = pkgs.nodejs_24;
  piAgentDir = "${config.home.homeDirectory}/.pi/agent";
  piConfigDir = "${dotfile}/pi";
in
{
  home.packages = [ pi ];

  # Put the store-backed executable before legacy npm-global binaries in PATH.
  home.sessionPath = [ "${pi}/bin" ];
  # Keep the whole Pi state/configuration in the dotfile submodule. Its
  # .gitignore excludes auth, sessions, npm packages, and other runtime data.
  home.sessionVariables.PI_CODING_AGENT_DIR = piAgentDir;
  home.file.".pi/agent" = {
    source = config.lib.file.mkOutOfStoreSymlink piConfigDir;
    force = true;
  };

  # Pi extensions are user-state by design. Install the pinned extension set on
  # first activation without asking pi to rewrite the symlinked settings file.
  home.activation.installPiExtensions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    export PATH="${node}/bin:$PATH"
    export PI_CODING_AGENT_DIR=${lib.escapeShellArg piAgentDir}
    export PI_PACKAGE_DIR="$PI_CODING_AGENT_DIR/npm"
    mkdir -p "$PI_CODING_AGENT_DIR" "$PI_PACKAGE_DIR"

    ensure_pi_npm_package() {
      local source="$1" package="$2" expected_version="$3"
      local manifest="$PI_PACKAGE_DIR/node_modules/$package/package.json"
      local installed_version=""

      if [ -f "$manifest" ]; then
        installed_version="$(${node}/bin/node -e 'process.stdout.write(require(process.argv[1]).version)' "$manifest" 2>/dev/null || true)"
      fi

      if [ "$installed_version" != "$expected_version" ]; then
        ${node}/bin/npm install \
          --prefix "$PI_PACKAGE_DIR" \
          --no-save \
          --no-package-lock \
          --ignore-scripts \
          "''${source#npm:}"
      fi
    }

    # The dotfile settings file is the source of truth for the extension set.
    # Only exact npm versions are pre-installed here; Pi itself handles any
    # other configured package source according to that same settings file.
    if [ -f "$PI_CODING_AGENT_DIR/settings.json" ]; then
      while IFS=$'\t' read -r source package expected_version; do
        [ -n "$source" ] || continue
        ensure_pi_npm_package "$source" "$package" "$expected_version"
      done < <(
        ${node}/bin/node -e '
          const fs = require("fs");
          const settings = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
          for (const entry of settings.packages || []) {
            const source = typeof entry === "string" ? entry : entry.source;
            if (typeof source !== "string" || !source.startsWith("npm:")) continue;
            const spec = source.slice(4);
            const at = spec.lastIndexOf("@");
            if (at <= 0) continue;
            const packageName = spec.slice(0, at);
            const version = spec.slice(at + 1);
            if (!/^[0-9]+[.][0-9]+[.][0-9]+$/.test(version)) continue;
            process.stdout.write(
              [source, packageName, version].join(String.fromCharCode(9)) + String.fromCharCode(10)
            );
          }
        ' "$PI_CODING_AGENT_DIR/settings.json"
      )
    fi
  '';
}
