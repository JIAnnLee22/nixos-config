# clashtui 0.3.1 overlay
#
# nixpkgs 目前仅含 clashtui 0.2.3，其配置 schema 与目录结构同 0.3.x 完全不兼容
# （0.3.0 起官方声明不向后兼容）。本 overlay 用 0.3.1 源码覆盖 nixpkgs 的 clashtui。
#
# 0.3.1 相对 nixpkgs 0.2.3 的打包差异：
#   - 源码顶层即 Cargo.toml（0.2.3 在 clashtui/ 子目录），故不再设置 sourceRoot。
#   - 新增 sing-box 支持、keymap/theme 配置等依赖，cargoHash 需重算。
final: prev:
{
  clashtui = prev.rustPlatform.buildRustPackage (finalAttrs: {
    pname = "clashtui";
    version = "0.3.1";

    src = prev.fetchFromGitHub {
      owner = "JohanChane";
      repo = "clashtui";
      tag = "v${finalAttrs.version}";
      hash = "sha256-roP252d0lO7eN2KCHiuPPI5o8QqtPWJvmeex8sAmKww=";
    };

    # 0.3.1 源码顶层即 Cargo.toml，无需 sourceRoot（默认就是 src 根）。

    cargoHash = "sha256-7y31iZoSJ98XDiC+Akahgfp/lI5haaek6UpFtaCtGW8=";

    cargoBuildFlags = [ "--all-features" ];

    # 0.2.3 的 checkFlags 跳过 utils::config::test::test_save_and_load（需 FHS）；
    # 0.3.1 路径不同，先全量测试，若有 FHS 依赖再按实际跳过。
    doInstallCheck = false;

    passthru.updateScript = prev.nix-update-script { };

    meta = {
      description = "Mihomo (Clash.Meta) / sing-box TUI Client";
      homepage = "https://github.com/JohanChane/clashtui";
      changelog = "https://github.com/JohanChane/clashtui/releases/tag/v${finalAttrs.version}";
      mainProgram = "clashtui";
      license = prev.lib.licenses.mit;
      platforms = prev.lib.platforms.linux;
      maintainers = [ ];
    };
  });
}
