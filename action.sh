#!/system/bin/sh
# Environment variable settings
export PATH="/data/adb/ap/bin:/data/adb/ksu/bin:/data/adb/magisk:$PATH"

module_dir="/data/adb/modules/Atun2socks"
scripts_dir="/data/adb/tun2socks/scripts"

restart_proxy() {
  if [ ! -f "${module_dir}/disable" ]; then
    echo "🔁Restart tun2socks"
    ${scripts_dir}/tun2socks.service disable >/dev/null 2>&1
    ${scripts_dir}/tun2socks.service enable >/dev/null 2>&1
  else
    echo "🥴 Module Disabled"
    sleep 1
    exit
  fi
}

restart_proxy
