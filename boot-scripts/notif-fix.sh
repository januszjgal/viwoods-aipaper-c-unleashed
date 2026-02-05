#!/system/bin/sh
# Bind mount patched services.jar to remove Viwoods notification whitelist
# This script requires notification-fix Magisk module to be installed
mount -o bind /data/adb/modules/notif-fix/system/framework/services.jar /system/framework/services.jar
