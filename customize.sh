#!/system/bin/sh

SKIPUNZIP=1
ASH_STANDALONE=1
unzip_path="/data/adb"

source_folder="/data/adb/tun2socks"
destination_folder="/data/adb/tun2socks$(date +%Y%m%d_%H%M%S)"

unzip -j -o "${ZIPFILE}" 'CHANGELOG.md' -d "${MODPATH}" >&2
cat "${MODPATH}/CHANGELOG.md"
rm -f "${MODPATH}/CHANGELOG.md"

if [ -d "${source_folder}" ]; then
  mv "${source_folder}" "${destination_folder}"
  ui_print "- Backing up existing files"
  rm -rf "${source_folder}"
else
  ui_print "- Performing initial installation"
fi

if [ -d "/data/adb/modules/Atun2socks" ]; then
  rm -rf "/data/adb/modules/Atun2socks"
  ui_print "- Old module has been removed"
fi

ui_print "- Releasing files"
unzip -o "${ZIPFILE}" 'tun2socks/*' -d "${unzip_path}" >&2
unzip -j -o "${ZIPFILE}" 'tun2socks.sh' -d /data/adb/service.d >&2
unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d "${MODPATH}" >&2
unzip -j -o "${ZIPFILE}" "action.sh" -d "${MODPATH}" >&2
unzip -j -o "${ZIPFILE}" "module.prop" -d "${MODPATH}" >&2
unzip -j -o "${ZIPFILE}" "system.prop" -d "${MODPATH}" >&2

if [ "${KSU}" = "true" ]; then
  sed -i "s/name=.*/name=tun2socks for KernelSU/g" "${MODPATH}/module.prop"
elif [ "${APATCH}" = "true" ]; then
  sed -i "s/name=.*/name=tun2socks for APatch/g" "${MODPATH}/module.prop"
else
  sed -i "s/name=.*/name=tun2socks for Magisk/g" "${MODPATH}/module.prop"
fi

largest_folder=$(find /data/adb -maxdepth 1 -type d -name 'tun2socks[0-9]*' | sed 's/.*tun2socks//' | sed 's/_//g' | sort -nr | head -n 1)

if [ -n "${largest_folder}" ]; then
  for folder in /data/adb/tun2socks*; do
    clean_name=$(echo "${folder}" | sed 's/.*tun2socks//' | sed 's/_//g')
    if [ "${clean_name}" = "${largest_folder}" ]; then
      ui_print "- Found folder: ${folder}"
      if [ -d "${folder}/conf" ]; then
        cp -rf "${folder}/conf/"* /data/adb/tun2socks/conf/
        ui_print "- Copied contents of ${folder}/conf to /data/adb/tun2socks/conf/"
        ui_print "- Configuration file restored successfully"
      fi
      break
    fi
  done
else
  ui_print "- First-time installation, no backup configuration available to restore"
fi

ui_print "- Setting permissions"
set_perm_recursive "${MODPATH}" 0 0 0755 0755
set_perm_recursive /data/adb/tun2socks/ 0 3005 0755 0755
set_perm /data/adb/service.d/tun2socks.sh 0 0 0755
ui_print "- Permissions set successfully"

pm install -r /data/adb/tun2socks/scripts/toast.apk && rm -f /data/adb/tun2socks/scripts/toast.apk || ui_print "- Please manually install toast.apk"
find "${source_folder}" -type f -name ".gitkeep" -exec rm -f {} +
ui_print "- enjoy!"
