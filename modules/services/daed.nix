# daed 代理服务
{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.daed ];
  systemd.packages = [ pkgs.daed ];
  systemd.services.daed = {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      umask 0077
      mkdir -p /etc/daed
      ln -sfn ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /etc/daed/
      ln -sfn ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /etc/daed/
    '';
    serviceConfig.ExecStart = [
      ""
      "${pkgs.daed}/bin/daed run -c /etc/daed -l 127.0.0.1:2023"
    ];
  };
}
