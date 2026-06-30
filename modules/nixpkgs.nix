# nixpkgs 全局配置
{ ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10" # logseq
    ];
    android_sdk.accept_license = true;
  };

  # 设置默认编辑器为 neovim
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
