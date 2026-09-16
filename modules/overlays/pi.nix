# pi-coding-agent 版本覆盖：锁定到 0.85.1。
#
# 当前 flake.lock 锁定的 nixpkgs（nixos-unstable）中 pi-coding-agent 仍是 0.82.1，
# 上游 nixpkgs HEAD 已提供 0.85.1。为避免整体更新 nixpkgs 带来的大范围重建，
# 用本 overlay 精准覆盖 pi 包。升级时同步 ./pi-coding-agent.nix 中的版本与 hash。
final: prev:
{
  pi-coding-agent = final.callPackage ./pi-coding-agent.nix { };
}
