{ inputs, pkgs, ... }:
let
  # GitHub Releases still points at the expired 262.9593.0 build.
  # Official replacement + checksums: https://github.com/Kotlin/kotlin-lsp/issues/271
  # Retain the input's autoPatchelf/JBR packaging, but pin the refreshed archive.
  kotlin_lsp = inputs.kotlin_lsp.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    version = "263.4421.0";
    src = pkgs.fetchurl {
      url = "https://download.jetbrains.com/language-server/kotlin-server/263.4421.0/kotlin-server-263.4421.0.tar.gz";
      hash = "sha256-0dq073s5qI93zPaNXloWXJ88Xg+bG7mSPmJaVL08Zz8=";
    };
    # Local packaging workaround for https://github.com/Kotlin/kotlin-lsp/issues/243
    # Use the Kotlin plugin's TCS classes instead of the identical duplicate copy
    # in the Gradle importer (different classloaders cannot cast). Revalidate on upgrade.
    postPatch = (old.postPatch or "") + ''
      ${pkgs.python3}/bin/python3 - <<'PY'
      from pathlib import Path
      from zipfile import ZipFile

      jar = Path("plugins/kotlin.lsp/lib/modules/language-server.workspace-import.gradle-plugin.jar")
      descriptor = "language-server.workspace-import.gradle-plugin.xml"
      tcs = "org/jetbrains/kotlin/gradle/idea/tcs/"
      with ZipFile(jar) as source:
          entries = [(entry, source.read(entry)) for entry in source.infolist()]
      duplicates = [(entry, data) for entry, data in entries if entry.filename.startswith(tcs)]
      assert len(duplicates) == 47, "upstream TCS layout changed"
      with ZipFile("plugins/kotlin/lib/intellij.kotlin.base.projectModel.jar") as model:
          assert all(model.read(entry.filename) == data for entry, data in duplicates), "TCS copies differ"
      patched = 0
      with ZipFile(jar, "w") as target:
          for entry, data in entries:
              if entry.filename.startswith(tcs):
                  continue
              if entry.filename == descriptor:
                  text = data.decode()
                  assert text.count("<dependencies>") == 1, "upstream descriptor changed"
                  text = text.replace("<dependencies>", '<dependencies>\n    <plugin id="org.jetbrains.ls.plugin.kotlin"/>', 1)
                  data = text.encode()
                  patched += 1
              target.writestr(entry, data)
      assert patched == 1, "missing Gradle importer descriptor"
      PY
    '';
    postInstall = (old.postInstall or "") + ''
      # Standard CLI name; keep intellij-server/kotlin_lsp for compatibility.
      test -x "$out/bin/intellij-server" || {
        echo "kotlin_lsp packaging changed: missing executable intellij-server" >&2
        exit 1
      }
      ln -sfn "$out/bin/intellij-server" "$out/bin/kotlin-lsp"
      test -x "$out/bin/kotlin-lsp"
    '';
  });
in
{
  home.packages = with pkgs; [
    # LSP servers (Neovim config is managed outside Home Manager)
    clang-tools
    lua-language-server
    # Only the official JetBrains Kotlin LSP; no fwcd fallback.
    kotlin_lsp
    jdt-language-server
    groovy-language-server
    lemminx
    nil
    rust-analyzer
  ];
}
