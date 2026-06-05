# JetBrains Kotlin Language Server
# 首次构建前：nix-store --add-fixed sha256 kotlin-server-262.4739.0.tar.gz
{ lib, stdenv, requireFile, makeWrapper }:

let
  version = "262.4739.0";
in

stdenv.mkDerivation {
  pname = "kotlin-lsp-jetbrains";
  inherit version;

  src = requireFile {
    name = "kotlin-server-${version}.tar.gz";
    hash = "sha256-RpcREMm4ozYM4/31Q3Rn9MRH2tN61z2/gdZK9neeQQU=";
    message = ''
      JetBrains kotlin-lsp 需要本地 tarball。
      将 kotlin-server-${version}.tar.gz 放到仓库根目录后执行：
        nix-store --add-fixed sha256 kotlin-server-${version}.tar.gz
    '';
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = "kotlin-server-${version}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out/

    makeWrapper "$out/bin/intellij-server" "$out/bin/kotlin-lsp"

    runHook postInstall
  '';

  meta = with lib; {
    description = "JetBrains Kotlin Language Server";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = licenses.asl20;
    platforms = platforms.linux;
    mainProgram = "kotlin-lsp";
  };
}
