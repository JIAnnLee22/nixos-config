[
  # Pi 0.87.0 尚未进入当前 nixos-unstable；固定上游发布版本。
  (_final: prev: {
    pi-coding-agent = prev.pi-coding-agent.overrideAttrs (finalAttrs: _previousAttrs: {
      version = "0.87.0";

      src = prev.fetchFromGitHub {
        owner = "earendil-works";
        repo = "pi";
        tag = "v${finalAttrs.version}";
        hash = "sha256-7YkIA5IEs4U0qnoaO3IzlY+p/M7j30fSVelLeyoV+F8=";
      };

      npmDepsHash = "sha256-fbxwpQHnrUihO9MU72m331Uwt9dv0fQtEjdJ9hU8UxA=";
      # buildNpmPackage materializes npmDeps before overrideAttrs, so refresh it
      # explicitly instead of retaining the 0.85.1 dependency cache.
      npmDeps = prev.fetchNpmDeps {
        name = "pi-coding-agent-${finalAttrs.version}-npm-deps";
        src = finalAttrs.src;
        hash = finalAttrs.npmDepsHash;
      };

      modelData = prev.fetchurl {
        url = "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-${finalAttrs.version}.tgz";
        hash = "sha256-8q353oCdA192+NrfPRSHIOvu9GBqhIqzbug02JWugS8=";
      };
    });
  })
]
