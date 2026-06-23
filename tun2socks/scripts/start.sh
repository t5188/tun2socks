#!/system/bin/sh
scripts_dir="$(cd "$(dirname "$0")" && pwd)"
. "${scripts_dir}/tun2socks.ini"

start_proxy() {
  if [[ ! -f "${module_dir}/disable" ]]; then
    ${scripts_dir}/tun2socks.service enable >/dev/null 2>&1
  else
    toast "Module Disabled"
  fi

  for PID in $(busybox pidof inotifyd 2>/dev/null); do
    if grep -q "${scripts_dir}/tun2socks.inotify" "/proc/$PID/cmdline"; then
      return
    fi
  done

  inotifyd "${scripts_dir}/tun2socks.inotify" "${module_dir}" >/dev/null 2>&1 &
}

start_proxy
