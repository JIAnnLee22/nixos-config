# ser 主机特定的网络配置（防火墙规则等）
{ ... }:

{
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 12345 3389 ];
    allowedUDPPorts = [ 12345 ];
  };
}
