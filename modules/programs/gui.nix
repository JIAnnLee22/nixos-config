# GUI 应用程序
{ pkgs, inputs, ... }:

let
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    # Android 开发所需的平台 SDK；仅使用真机，不打包模拟器、镜像或 SDK 源码。
    platformVersions = [ "34" "35" "36" ];
    buildToolsVersions = [ "34.0.0""35.0.0" "36.0.0" ];
    includeEmulator = false;
    includeSystemImages = false;
    includeSources = false;
    # 保留 C/C++/JNI 开发工具链。
    includeNDK = true;
    includeCmake = true;
  };
  androidSdkRoot = "${androidSdk.androidsdk}/libexec/android-sdk";
  androidStudioWithSdk = pkgs.android-studio.withSdk androidSdk.androidsdk;
  androidStudioVmOptions = pkgs.writeText "android-studio.vmoptions" ''
    # SDK 由 Nix 完整提供；禁止首次启动向导再次尝试下载并写入只读的 Nix Store。
    -Ddisable.android.first.run=true
  '';
  androidStudio = pkgs.symlinkJoin {
    name = "android-studio-with-sdk-${pkgs.android-studio.version}";
    paths = [ androidStudioWithSdk ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/android-studio" \
        --set STUDIO_VM_OPTIONS ${androidStudioVmOptions}
    '';
  };

  feishu = pkgs.feishu;
  feishuWayland = pkgs.symlinkJoin {
    name = "${feishu.name}-wayland-ime";
    paths = [ feishu ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/opt/bytedance/feishu/bytedance-feishu" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--enable-wayland-ime" \
        --add-flags "--wayland-text-input-version=3"

      # 上游 desktop 使用绝对 store 路径，必须改为包装后的启动器。
      rm "$out/share/applications/bytedance-feishu.desktop"
      substitute "${feishu}/share/applications/bytedance-feishu.desktop" \
        "$out/share/applications/bytedance-feishu.desktop" \
        --replace-fail \
          "Exec=${feishu}/opt/bytedance/feishu/bytedance-feishu %U" \
          "Exec=$out/opt/bytedance/feishu/bytedance-feishu %U"
    '';
  };
in
{
  # 让 Gradle、Neovim 等命令行工具复用 Android Studio 的声明式 SDK。
  environment.sessionVariables = {
    ANDROID_HOME = androidSdkRoot;
    ANDROID_SDK_ROOT = androidSdkRoot;
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    inputs.qq.packages.${pkgs.system}.default
    feishuWayland
    mpv
    pcmanfm
    freerdp
    remmina
    qemu_kvm
    # 图形化 askpass 程序
    x11_ssh_askpass
    vial
    androidStudio
    # 暴露 adb、fastboot 等 platform-tools 命令。
    androidSdk.platform-tools
    scrcpy
    kitty
    motrix
    zenity
    flameshot
  ];
}
