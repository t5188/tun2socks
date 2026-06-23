#!/system/bin/sh
export PATH="/data/adb/ap/bin:/data/adb/ksu/bin:/data/adb/magisk:$PATH"
scripts_dir="/data/adb/tun2socks/scripts"
(
  resetprop -w sys.boot_completed
  "${scripts_dir}/start.sh"
) &
exit 0
