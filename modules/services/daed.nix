# daed 代理服务
{ pkgs, ... }:

let
  # 合并 geoip 与 geosite 数据包，daed 通过 DAE_LOCATION_ASSET 环境变量定位这些文件
  geoAssets = pkgs.symlinkJoin {
    name = "daed-geo-assets";
    paths = [
      pkgs.v2ray-geoip
      pkgs.v2ray-domain-list-community
    ];
  };
in
{
  environment.systemPackages = [ pkgs.daed ];
  systemd.packages = [ pkgs.daed ];
  systemd.services.daed = {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      umask 0077
      mkdir -p /etc/daed
    '';
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.daed}/bin/daed run -c /etc/daed -l 127.0.0.1:2023"
      ];
      # 告知 daed/dae 在哪里寻找 geoip.dat / geosite.dat
      Environment = "DAE_LOCATION_ASSET=${geoAssets}/share/v2ray";
    };
  };
}
