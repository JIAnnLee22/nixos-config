[
  # Pi 0.87.1 尚未进入当前 nixos-unstable；固定上游发布版本。
  (_final: prev: {
    pi-coding-agent = prev.pi-coding-agent.overrideAttrs (finalAttrs: _previousAttrs: {
      version = "0.87.1";

      src = prev.fetchFromGitHub {
        owner = "earendil-works";
        repo = "pi";
        tag = "v${finalAttrs.version}";
        hash = "sha256-GUhlq6t+l6iiViOZ0bkV28v3ZDqcLvEwpZpYZ5JAyDk=";
      };

      npmDepsHash = "sha256-JBIYoP2vvRNz1HONNvDJ1U3c+nmCJ7/VgNthRTkrkIA=";
      # buildNpmPackage materializes npmDeps before overrideAttrs, so refresh it
      # explicitly instead of retaining the 0.85.1 dependency cache.
      npmDeps = prev.fetchNpmDeps {
        name = "pi-coding-agent-${finalAttrs.version}-npm-deps";
        src = finalAttrs.src;
        hash = finalAttrs.npmDepsHash;
      };

      modelData = prev.fetchurl {
        url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${finalAttrs.version}.tgz";
        hash = "sha256-NbRDLyfMJmX4a+67mvajmxJRlwiDwwRL2L5PToxzHKA=";
      };
    });
  })
]
