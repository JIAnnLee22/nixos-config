# 自定义 st (Simple Terminal) 构建
{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.st.overrideAttrs (oldAttrs: rec {
      src = pkgs.fetchFromGitHub {
        owner = "JIAnnLee22";
        repo = "st";
        rev = "ce3fa02a182070bd62b0da82398667d5a365952d";
        sha256 = "sha256-GtIJebINcpVC+W0gy6/KZt9sPGlGnuEzoB7LgzdBqFk=";
      };
    }))
  ];
}
