# Tencent app download URLs expire or mirrors break; override until nixpkgs updates.
final: prev: {
  qq = prev.qq.overrideAttrs (_: {
    version = "3.2.29-2026-05-28";
    src = prev.fetchurl {
      url = "https://qqdl.gtimg.cn/qqfile/QQNT/9.9.31/release/00e6a3e7/QQ_3.2.29_260528_amd64_01.deb";
      hash = "sha256-HjgoB5ZzyUmUvA9HgNXYUoZHY5kgZZhi1J0cLyoZjiU=";
    };
  });

  wechat = prev.wechat.overrideAttrs (_: {
    src = prev.fetchurl {
      url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
      hash = "sha256-XxAvFnlljqurGPDgRr+DnuCKbdVvgXBPh02DLHY3Oz8=";
    };
  });
}
