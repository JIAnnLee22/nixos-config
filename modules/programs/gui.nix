# GUI 应用程序
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    google-chrome
    wechat
    qq
    feishu
    mpv
    pcmanfm
    logseq
    foot
    freerdp
    remmina
    qemu_kvm
    # 图形化 askpass 程序
    x11_ssh_askpass
    vial
  ];
}
