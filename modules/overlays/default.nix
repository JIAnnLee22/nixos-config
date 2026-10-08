{ inputs ? null }:
[
  # Pi 固定上游发布版本 (1.1.0)
  (final: prev: {
    pi-coding-agent =
      if inputs != null && inputs ? pi then
        prev.symlinkJoin {
          name = "pi-coding-agent-${inputs.pi.packages.${prev.system}.default.version}";
          pname = "pi-coding-agent";
          version = inputs.pi.packages.${prev.system}.default.version;
          paths = [ inputs.pi.packages.${prev.system}.default ];
          nativeBuildInputs = [ prev.makeBinaryWrapper ];
          postBuild = ''
            wrapProgram $out/bin/pi \
              --set-default PI_SKIP_VERSION_CHECK 1 \
              --set-default PI_TELEMETRY 0
          '';
        }
      else
        prev.pi-coding-agent;
    pi = final.pi-coding-agent;
  })
]
