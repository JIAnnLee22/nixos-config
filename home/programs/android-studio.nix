# Android Studio 用户状态迁移
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # 旧配置在系统没有 Secret Service 时会退化为 MEMORY_ONLY，导致 Google/Gemini
  # 等登录令牌在 IDE 退出后立即丢失。只迁移该退化值，保留用户主动选择的
  # KEEPASS 或 DO_NOT_STORE。
  home.activation.androidStudioPasswordSafe = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for security_file in \
      "${config.home.homeDirectory}"/.config/Google/AndroidStudio*/options/security.xml; do
      if [ ! -f "$security_file" ]; then
        continue
      fi

      if ${pkgs.gnugrep}/bin/grep -q 'value="MEMORY_ONLY"' "$security_file"; then
        ${pkgs.gnused}/bin/sed -i 's/value="MEMORY_ONLY"/value="KEYCHAIN"/' "$security_file"
      fi
    done
  '';
}
