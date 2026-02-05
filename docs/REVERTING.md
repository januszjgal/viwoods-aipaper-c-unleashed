# Reverting to Stock

This guide explains how to undo all modifications and return to a stock-like state.

## Quick Revert (Keep Root)

Remove all customizations but keep Magisk installed:

```bash
# Remove all Magisk modules
adb shell su -c "rm -rf /data/adb/modules/*"

# Remove boot scripts
adb shell su -c "rm -rf /data/adb/service.d/*"

# Reset modified settings
adb shell settings put global wifi_sleep_policy 2
adb shell settings put global mobile_data_always_on 0
adb shell settings put global app_standby_enabled 1
adb shell settings put global adaptive_battery_management_enabled 1
adb shell settings put global window_animation_scale 1.0
adb shell settings put global transition_animation_scale 1.0
adb shell settings put global animator_duration_scale 1.0

# Re-enable Doze
adb shell dumpsys deviceidle enable

# Reboot
adb reboot
```

## Complete Unroot

Remove Magisk entirely:

### Option 1: Restore Stock Boot Image (Recommended)

If you have a backup of your original `init_boot`:

```bash
# Flash original init_boot
adb push init_boot_b_stock.img /sdcard/
adb shell su -c "dd if=/sdcard/init_boot_b_stock.img of=/dev/block/by-name/init_boot_b"
adb reboot
```

### Option 2: Uninstall via Magisk App

1. Open Magisk app
2. Tap "Uninstall Magisk"
3. Choose "Complete Uninstall"
4. Device will reboot without root

### Option 3: Factory Reset

1. Boot to recovery (Power + Volume Up)
2. Select "Wipe data/factory reset"
3. Confirm and reboot

**Note:** This removes all user data

## Re-enable Blocked System Apps

If you disabled any system apps:

```bash
# Re-enable NFC
adb shell pm enable com.android.nfc

# Re-enable other disabled packages
adb shell pm enable com.android.virtualization.terminal
adb shell pm enable com.android.devicelockcontroller
```

## Restore Default Launcher

If you changed the default launcher:

```bash
# List available launchers
adb shell pm list packages -d | grep launcher

# Enable Viwoods launcher if disabled
adb shell pm enable com.viwoods.launcher

# Set as default (may need to do via Settings app)
```

Or go to **Settings** > **Apps** > **Default apps** > **Home app** and select Viwoods Launcher.

## Restore Default Keyboard

```bash
# Enable Viwoods keyboard
adb shell pm enable com.viwoods.viwoodsime

# Set as default
adb shell ime set com.viwoods.viwoodsime/.WiskyPinyinIME
```

## Remove User-Installed Apps

To get closer to stock, uninstall added apps:

```bash
# Uninstall Magisk
adb shell pm uninstall com.topjohnwu.magisk

# Uninstall other user apps
adb shell pm uninstall <package-name>
```

## Full Stock Recovery

If you need to completely restore to factory firmware:

### Option 1: OTA Update

If a newer OTA is available:
1. Go to **Settings** > **System** > **System updates**
2. Download and install update
3. This will replace modified partitions

**Warning:** OTA may fail if system is modified. You may need to restore stock partitions first.

### Option 2: Factory Firmware Flash

1. Obtain stock firmware for your device (contact Viwoods support)
2. Use MediaTek flash tool (SP Flash Tool) to flash complete firmware
3. This will wipe everything including data

## Verification

After reverting, verify the device is stock:

```bash
# Check no Magisk
adb shell su
# Should fail with "su: not found"

# Check no modules
adb shell ls /data/adb/modules
# Should be empty or not exist

# Check Doze is enabled
adb shell dumpsys deviceidle
# Should show enabled states

# Check default settings restored
adb shell settings get global wifi_sleep_policy
# Should be: 2 (default)
```

## Keeping Specific Modifications

If you want to keep some modifications while removing others:

### Keep only root
```bash
# Remove all modules except keep Magisk
adb shell su -c "ls /data/adb/modules"
# Selectively remove: rm -rf /data/adb/modules/<module-name>
```

### Keep only settings changes
```bash
# Remove modules and scripts
adb shell su -c "rm -rf /data/adb/modules/*"
adb shell su -c "rm -rf /data/adb/service.d/*"
# Settings will persist until manually changed
```

### Keep only AI Key remap
```bash
# Remove other modules
adb shell su -c "rm -rf /data/adb/modules/notification-fix"
adb shell su -c "rm -rf /data/adb/modules/android-auto-system"
adb shell su -c "rm /data/adb/service.d/disable_doze.sh"
adb shell su -c "rm /data/adb/service.d/notification_wake.sh"
# Keep ai_key_remap module
```
