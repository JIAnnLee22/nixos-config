{ pkgs, ... }:
{
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    stylua

    # === Mason LSP 运行时依赖 ===
    python3          # jdtls (Java LSP) 启动脚本需要
    cargo            # mason 安装 Rust 系 LSP (nil, rust-analyzer) 需要
    nodejs           # JS/TS 系 LSP 服务器需要
    unzip            # mason 解压 LSP 包需要
  ];
}
