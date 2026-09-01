# bash

_file=~/Pictures/$(date +'%Y_%m%d_%H%M_%S_grim.png')
# 获取当前 active 显示器名（mmsg get all-monitors 输出 JSON；旧语法 mmsg -g 已废弃）
_output=$(mmsg get all-monitors | grep -o '"name":"[^"]*","active":true' | head -1 | cut -d'"' -f4)
# Keep file extension and encoded format aligned to avoid broken images.
if [ -n "$_output" ]; then
  grim -o "$_output" -t png "$_file"
else
  # 兜底：截全部显示器
  grim -t png "$_file"
fi
satty --disable-notifications --fullscreen --early-exit --no-window-decoration --annotation-size-factor 1 --action-on-enter save-to-file --actions-on-right-click save-to-clipboard --copy-command "wl-copy --type image/png" --corner-roundness 0 --initial-tool crop --filename="$_file" -o "$_file"
