# Troubleshooting

Common issues and solutions for the Viwoods AiPaper C Unleashed modifications.

## Boot Issues

### Device bootloops after installing module
**Solution:**
1. Wait 3-5 minutes - A/B devices may auto-switch slots
2. If it doesn't recover:
   ```bash
   # Boot to recovery (hold Power + Volume Up while booting)
   # Connect via ADB
   adb shell
   rm -rf /data/adb/modules/<problem-module>
   reboot
   ```

### Device boots but Magisk is gone
**Cause:** System update or slot switch
**Solution:** Re-patch and flash `init_boot` for the new slot

## Notification Issues

### Notifications still not showing from third-party apps
**Causes:**
1. notification-fix module not installed
2. Patched services.jar not mounted
3. App notification permissions not granted

**Solutions:**
```bash
# Check if notif-fix is running
adb shell mount | grep services.jar

# Check app notification permissions
adb shell dumpsys notification | grep <package-name>

# Manually test notification
adb shell am broadcast -a android.intent.action.NOTIFICATION_LISTENER_SETTINGS
```

### Notification wake script not working
**Debug:**
```bash
# Check if script is running
adb shell pgrep -f notification_wake

# Check logcat for errors
adb shell logcat | grep NotifWake

# Test manually
adb shell su -c 'sh /data/adb/service.d/notification_wake.sh &'

# Send test notification
adb shell am broadcast -a android.intent.action.NOTIFICATION_POLICY_CHANGED
```

## Power Management Issues

### WiFi disconnects when screen off
**Check:**
```bash
# Verify setting
adb shell settings get global wifi_sleep_policy
# Should be: 0

# Check Doze status
adb shell dumpsys deviceidle

# Re-apply settings
adb shell settings put global wifi_sleep_policy 0
adb shell dumpsys deviceidle disable
```

### Apps being killed in background
**Cause:** Adaptive battery or app standby
**Solution:**
```bash
adb shell settings put global app_standby_enabled 0
adb shell settings put global adaptive_battery_management_enabled 0
adb shell cmd appops set <package> RUN_IN_BACKGROUND allow
```

## AI Key Issues

### AI Key does nothing after installing remap module
**Debug:**
```bash
# Check if service is running
adb shell pgrep -f getevent

# Check input device
adb shell getevent -l /dev/input/event6

# Press AI key and look for output
# Should show: EV_KEY KEY_F1 DOWN/UP

# Check keylayout is mounted
adb shell ls -la /system/usr/keylayout/ | grep AI_KEY
```

### AI Key still launches Viwoods AI app
**Cause:** Keylayout not applied or wrong input device
**Solution:**
```bash
# Find correct input device
adb shell getevent -l
# Press AI key and note which event# shows activity

# Update service.sh with correct event device
# Edit EVENT=/dev/input/event6 to correct number
```

## Android Auto Issues

### Android Auto not detected as system app
**Check:**
```bash
adb shell pm list packages -s | grep gearhead
# Should show: package:com.google.android.projection.gearhead
```

**If not listed:** Module not properly installed
```bash
# Verify structure
adb shell ls -la /data/adb/modules/android-auto-system/system/priv-app/AndroidAuto/
```

### USB connection issues with car
**Solutions:**
1. Check USB config:
   ```bash
   adb shell getprop persist.sys.usb.config
   # Should be: mtp,adb
   ```
2. Try different USB cable
3. Check car head unit compatibility
4. Clear Android Auto app data

## ADB Issues

### Can't connect via ADB
**Solutions:**
1. Re-enable USB debugging
2. Revoke and re-authorize USB debugging
3. Check USB cable (use data cable, not charge-only)
4. Restart ADB:
   ```bash
   adb kill-server
   adb start-server
   adb devices
   ```

### ADB shows "unauthorized"
**Solution:** Check device screen for authorization prompt and accept it

### ADB works but `su` fails
**Causes:**
1. Magisk not fully installed
2. ADB shell not granted root
**Solution:** Open Magisk app and grant root to shell

## Performance Issues

### Device feels slow
**E-ink optimization:**
```bash
# Disable animations
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0
```

### High battery drain
**Check what's using battery:**
```bash
adb shell dumpsys batterystats
adb shell dumpsys battery
```

**Common culprits:**
- notification_wake script (monitoring logcat)
- WiFi always on
- Mobile data always on

## Logs and Debugging

### Collect logs for debugging
```bash
# Full system log
adb logcat -d > logcat.txt

# Boot-specific logs
adb shell dmesg > dmesg.txt

# Magisk logs
adb shell cat /data/adb/magisk.log > magisk.log

# Search for specific tags
adb logcat -s BootFixes:* NotifWake:* Magisk:*
```

### Check module errors
```bash
# Module load errors
adb shell cat /data/adb/magisk_debug.log

# Service script errors
adb logcat | grep -E "service\.d|BootFixes"
```

## Recovery Options

### Factory reset
1. Boot to recovery (Power + Volume Up)
2. Select "Wipe data/factory reset"
3. Confirm and reboot

**Note:** This removes all user data but preserves Magisk

### Remove all modifications
```bash
# Remove all Magisk modules
adb shell su -c "rm -rf /data/adb/modules/*"

# Remove service scripts
adb shell su -c "rm -rf /data/adb/service.d/*"

# Reboot
adb reboot
```

### Restore stock boot image
```bash
# If you have backups
adb push init_boot_b.img /sdcard/
adb shell su -c "dd if=/sdcard/init_boot_b.img of=/dev/block/by-name/init_boot_b"
adb reboot
```
