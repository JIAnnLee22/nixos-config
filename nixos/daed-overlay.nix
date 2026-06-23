final: prev:
let
  version = "1.27.0";

  daed-bin = prev.fetchzip {
    url = "https://github.com/daeuniverse/daed/releases/download/v${version}/daed-linux-x86_64.zip";
    hash = "sha256-NP5108NP92qVhtL6KvqYX/C0XU2o+oJyozoHKgaCWGY=";
  };
in
{
  daed = prev.stdenv.mkDerivation {
    pname = "daed";
    inherit version;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/lib/systemd/system

      install -Dm755 ${daed-bin}/daed-linux-x86_64 $out/bin/daed
      install -Dm644 ${daed-bin}/daed.service $out/lib/systemd/system/daed.service
      substituteInPlace $out/lib/systemd/system/daed.service \
        --replace-fail /usr/bin/daed $out/bin/daed

      runHook postInstall
    '';

    meta = {
      description = "Modern dashboard with dae";
      homepage = "https://github.com/daeuniverse/daed";
      license = prev.lib.licenses.mit;
      platforms = prev.lib.platforms.linux;
      mainProgram = "daed";
    };
  };
}
