# Bash 配置
{ config, ... }:

{
  # Interactive non-login bash only reads ~/.bashrc; without it, hm-session-vars.sh
  # (PATH, GOBIN, GOPATH from Home Manager) is never sourced — `go install` tools stay missing.
  programs.bash = {
    enable = true;
    profileExtra = ''
      export PATH="$PATH:${config.home.homeDirectory}/.local/share/JetBrains/Toolbox/scripts"
    '';
    # HM only puts hm-session-vars in ~/.profile; Kitty (and most terminals) start a
    # non-login bash, which never reads ~/.profile — only this block runs (after $- check).
    initExtra = ''
      if [[ -r "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh" ]]; then
        . "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };
}
