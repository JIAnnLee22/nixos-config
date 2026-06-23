# Tencent app download URLs expire or mirrors break; override until nixpkgs updates.
final: prev: {
  qq = prev.qq.overrideAttrs (_: {
    version = "3.2.29-2026-05-28";
    src = prev.fetchurl {
      url = "https://qqdl.gtimg.cn/qqfile/QQNT/9.9.31/release/00e6a3e7/QQ_3.2.29_260528_amd64_01.deb";
      hash = "sha256-HjgoB5ZzyUmUvA9HgNXYUoZHY5kgZZhi1J0cLyoZjiU=";
    };
  });

  # wechat 包使用 appimageTools，需要特殊处理
  # 直接覆盖 src 无法生效，因为 src 是在 callPackage 时传递的
  wechat = let
    version = "4.1.1.4";
    src = prev.fetchurl {
      url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
      hash = "sha256-vTTkuFm1LhAqVvuynIfYdROPf19nfCQIOGhw6Z+dOeo=";
    };
    appimageContents = prev.appimageTools.extract {
      pname = "wechat";
      inherit version src;
      postExtract = ''
        patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
      '';
    };
  in prev.appimageTools.wrapAppImage {
    pname = "wechat";
    inherit version;
    meta = {
      description = "Messaging and calling app";
      homepage = "https://www.wechat.com/en/";
      license = prev.lib.licenses.unfree;
      mainProgram = "wechat";
      platforms = [ "x86_64-linux" "aarch64-linux" ];
    };
    src = appimageContents;
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${appimageContents}/wechat.desktop $out/share/applications/
      mkdir -p $out/share/icons/hicolor/256x256/apps
      cp ${appimageContents}/wechat.png $out/share/icons/hicolor/256x256/apps/
      substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat
    '';
  };
}
