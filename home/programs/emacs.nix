{ pkgs, ... }:

let
  emacsWithPkgs = (pkgs.emacsPackagesFor pkgs.emacs).emacsWithPackages (epkgs: with epkgs; [ company which-key nix-mode lua-mode rust-mode ]);

  emacsTui = pkgs.symlinkJoin {
    name = "emacs-tui";
    paths = [ emacsWithPkgs ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/emacs" --add-flags "-nw"
    '';
  };
in
{
  home.packages = [ emacsTui ];

  xdg.configFile."emacs/init.el".source = ./emacs/init.el;
}
