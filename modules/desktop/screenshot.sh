# bash

_file=~/Pictures/$(date +'%Y_%m%d_%H%M_%S_grim.png')
_output=$(mmsg -g | grep 'selmon 1' | awk '{print $1}')
# Keep file extension and encoded format aligned to avoid broken images.
grim -o "$_output" -t png "$_file"
satty --disable-notifications --fullscreen --early-exit --no-window-decoration --annotation-size-factor 1 --action-on-enter save-to-file --actions-on-right-click save-to-clipboard --copy-command "wl-copy --type image/png" --corner-roundness 0 --initial-tool crop --filename="$_file" -o "$_file"
