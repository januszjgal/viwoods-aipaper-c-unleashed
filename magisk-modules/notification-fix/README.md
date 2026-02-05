# Notification Fix Module

The Viwoods AiPaper C has a customized `services.jar` that implements a notification whitelist, blocking notifications from non-Viwoods apps. This module replaces the framework with a patched version that removes this restriction.

## The Problem

Viwoods modified the Android notification system to only show notifications from approved apps (mostly Viwoods apps). This means you won't see notifications from third-party apps like Signal, WhatsApp, Gmail, etc.

## The Solution

This module replaces `/system/framework/services.jar` with a patched version that removes the whitelist check.

**Note**: The patched `services.jar` is NOT included in this repository due to:
1. Copyright concerns (proprietary Viwoods code)
2. Firmware version compatibility (each firmware needs its own patch)

You must create your own patched `services.jar` following the instructions below.

## Patching Instructions

See [PATCHING.md](PATCHING.md) for detailed instructions on how to:
1. Extract services.jar from your device
2. Decompile with jadx
3. Find and remove the whitelist check
4. Recompile with apktool
5. Install the patched version

## Installation

After creating your patched `services.jar`:

1. Create the module structure:
   ```
   /data/adb/modules/notification-fix/
   ├── module.prop
   └── system/
       └── framework/
           └── services.jar
   ```

2. Copy your patched `services.jar` to `/data/adb/modules/notification-fix/system/framework/`

3. Set permissions:
   ```bash
   chmod 644 /data/adb/modules/notification-fix/system/framework/services.jar
   ```

4. Add this script to `/data/adb/service.d/notif-fix.sh`:
   ```bash
   #!/system/bin/sh
   mount -o bind /data/adb/modules/notification-fix/system/framework/services.jar /system/framework/services.jar
   ```

5. Make it executable:
   ```bash
   chmod 755 /data/adb/service.d/notif-fix.sh
   ```

6. Reboot

## Verification

After reboot, test by sending yourself a notification from a third-party app (e.g., send yourself a test email or message).

If notifications still don't appear, check logcat for errors:
```bash
adb shell logcat | grep -i notification
```
