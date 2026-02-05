# Android Auto System App Module

This module installs Android Auto as a system privileged app, which is required for proper functionality with car head units. It also sets the USB configuration to `mtp,adb` which helps with Android Auto connectivity.

## Why System App?

Android Auto requires certain privileged permissions that are only available to system apps:
- Direct USB accessory access
- Overlay permissions
- Background activity launch permissions

Installing as a user app may result in:
- Connection issues with car head units
- Permission prompts that can't be permanently granted
- Background restrictions killing the app

## Installation

### Step 1: Get Android Auto APK

Extract the APK from your device or download from a trusted source:

```bash
# If Android Auto is already installed as a user app:
adb shell pm path com.google.android.projection.gearhead

# Pull the APK(s)
adb pull /data/app/~~xxx==/com.google.android.projection.gearhead-xxx==/base.apk AndroidAuto.apk
adb pull /data/app/~~xxx==/com.google.android.projection.gearhead-xxx==/split_config.arm64_v8a.apk
adb pull /data/app/~~xxx==/com.google.android.projection.gearhead-xxx==/split_config.en.apk
adb pull /data/app/~~xxx==/com.google.android.projection.gearhead-xxx==/split_config.xhdpi.apk
```

### Step 2: Create Module Structure

```
/data/adb/modules/android-auto-system/
├── module.prop
├── system.prop
└── system/
    └── priv-app/
        └── AndroidAuto/
            ├── AndroidAuto.apk
            ├── split_config.arm64_v8a.apk
            ├── split_config.en.apk
            └── split_config.xhdpi.apk
```

### Step 3: Copy Files

```bash
# Create directories
adb shell su -c "mkdir -p /data/adb/modules/android-auto-system/system/priv-app/AndroidAuto"

# Copy module files
adb push module.prop /sdcard/
adb push system.prop /sdcard/
adb shell su -c "cp /sdcard/module.prop /data/adb/modules/android-auto-system/"
adb shell su -c "cp /sdcard/system.prop /data/adb/modules/android-auto-system/"

# Copy APKs
adb push AndroidAuto.apk /sdcard/
adb push split_config.arm64_v8a.apk /sdcard/
adb push split_config.en.apk /sdcard/
adb push split_config.xhdpi.apk /sdcard/
adb shell su -c "cp /sdcard/AndroidAuto.apk /data/adb/modules/android-auto-system/system/priv-app/AndroidAuto/"
adb shell su -c "cp /sdcard/split_config.*.apk /data/adb/modules/android-auto-system/system/priv-app/AndroidAuto/"
```

### Step 4: Set Permissions

```bash
adb shell su -c "chmod 644 /data/adb/modules/android-auto-system/system/priv-app/AndroidAuto/*.apk"
adb shell su -c "chmod 755 /data/adb/modules/android-auto-system/system/priv-app/AndroidAuto"
adb shell su -c "chmod 755 /data/adb/modules/android-auto-system/system/priv-app"
adb shell su -c "chmod 755 /data/adb/modules/android-auto-system/system"
```

### Step 5: Uninstall User App (if installed)

```bash
adb shell pm uninstall com.google.android.projection.gearhead
```

### Step 6: Reboot

```bash
adb reboot
```

## Verification

After reboot:

```bash
# Check if installed as system app
adb shell pm list packages -s | grep gearhead
# Should show: package:com.google.android.projection.gearhead

# Check USB config
adb shell getprop persist.sys.usb.config
# Should show: mtp,adb
```

## Troubleshooting

### "App not installed" error
- Make sure you uninstalled the user app first
- Check APK permissions (should be 644)
- Check directory permissions (should be 755)

### Android Auto won't connect to car
- Ensure USB config is set correctly
- Try different USB cables
- Check that your car's head unit is compatible

### USB debugging stops working
- The `mtp,adb` config should preserve ADB access
- If issues occur, boot to recovery and modify `system.prop`
