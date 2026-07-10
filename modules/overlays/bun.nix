# bun 1.3.14 overlay
#
# nixpkgs 当前版本 bun 1.3.13，部分工具（如 omp）要求 >= 1.3.14。
# 本 overlay 用 1.3.14 的预编译二进制覆盖 nixpkgs 的 bun。
final: prev:
let
  version = "1.3.14";
  newSources = {
    "x86_64-linux" = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-lR7iruhV8IWVruxiJSJqKY0/6oOj3NZGXAnLzN9+hI8=";
    };
    "aarch64-linux" = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-on/7Y6gxA3WDbg1vZorhf6jY0YuIw3yCHGUzGXOhmjs=";
    };
    "aarch64-darwin" = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-2LliIYKK1vl6x6wKt+lYcjQa92MAHogD6CZ2UsJlJiA=";
    };
    "x86_64-darwin" = prev.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
      hash = "sha256-PjWtb1OXGpg0v55nhuKt9ytfGSHMmpxf3gc9KXKUQHY=";
    };
  };
in
{
  bun = prev.bun.overrideAttrs (old: {
    inherit version;

    src =
      newSources.${prev.stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${prev.stdenvNoCC.hostPlatform.system}");

    passthru = old.passthru // {
      sources = newSources;
    };
  });
}
