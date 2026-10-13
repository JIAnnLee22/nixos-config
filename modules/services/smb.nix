# Windows 网络共享（SMB/CIFS）客户端支持
# - gvfs + samba 后端：让 pcmanfm 可通过 smb:// URI 直接浏览 Windows 共享
# - cifs-utils：提供 mount.cifs，用于手动或 fstab 挂载
# - samba 客户端工具：smbclient、nmblookup 等
{ pkgs, ... }:

{
  # gvfs 是 GNOME 虚拟文件系统，pcmanfm 依赖它来挂载 smb:// 网络位置。
  # 启用 samba 后端后，用户可在地址栏输入 smb://主机名/共享名 直接访问。
  services.gvfs = {
    enable = true;
    package = pkgs.gvfs;
  };

  environment.systemPackages = with pkgs; [
    # CIFS/SMB 挂载工具（mount.cifs、umount.cifs）
    cifs-utils
    # Samba 客户端套件（smbclient、nmblookup、smbget 等）
    samba
    # keyutils：支持将 SMB 凭据存入内核钥匙环，避免明文密码写入 fstab
    keyutils
  ];

  # 若防火墙开启，允许 SMB 流量（仅限局域网方向，出站不需额外规则）
  # networking.firewall.allowedTCPPorts = [ 445 139 ];  # 仅在需要对外暴露时取消注释
}
