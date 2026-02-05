# Patching services.jar to Remove Notification Whitelist

This guide explains how to patch the Viwoods `services.jar` to remove the notification whitelist restriction.

## Prerequisites

- A computer with Java installed
- [jadx](https://github.com/skylot/jadx) - for decompiling
- [apktool](https://ibotpeaches.github.io/Apktool/) - for recompiling (optional)
- Basic knowledge of smali or Java bytecode

## Step 1: Extract services.jar

```bash
# Connect device via ADB
adb shell su -c "cp /system/framework/services.jar /sdcard/"
adb pull /sdcard/services.jar
```

## Step 2: Decompile with jadx

```bash
jadx -d services_decompiled services.jar
```

Or use the jadx GUI for easier navigation.

## Step 3: Find the Whitelist Code

Search for notification-related classes. The whitelist is typically in:
- `com/android/server/notification/NotificationManagerService.java`

Look for code that:
1. Checks package names against a list
2. Returns early or blocks notifications for non-whitelisted apps
3. References Viwoods package names (`com.viwoods.*`)

Common patterns to search for:
```java
// Search for these strings
"viwoods"
"notification"
"whitelist"
"allowlist"
"isAllowed"
"shouldFilter"
```

## Step 4: Identify the Check

The whitelist code typically looks something like:

```java
private boolean isNotificationAllowed(String packageName) {
    // Viwoods whitelist check
    if (packageName.startsWith("com.viwoods.")) {
        return true;
    }
    // Check against whitelist
    return ALLOWED_PACKAGES.contains(packageName);
}
```

Or in the notification posting flow:

```java
void enqueueNotification(...) {
    // ...
    if (!isNotificationAllowed(pkg)) {
        return; // Block notification
    }
    // ...
}
```

## Step 5: Patch the Code

**Option A: Make the function always return true**

Change:
```java
private boolean isNotificationAllowed(String packageName) {
    // ... whitelist logic ...
}
```

To:
```java
private boolean isNotificationAllowed(String packageName) {
    return true; // Allow all notifications
}
```

**Option B: Remove the check entirely**

Find where `isNotificationAllowed()` is called and remove/bypass the check.

## Step 6: Recompile

### Using smali (recommended for accuracy)

1. Disassemble the JAR:
   ```bash
   java -jar baksmali.jar d classes.dex -o smali_out
   ```

2. Edit the relevant `.smali` file to modify the bytecode

3. Reassemble:
   ```bash
   java -jar smali.jar a smali_out -o classes.dex
   ```

4. Replace the dex in the JAR:
   ```bash
   zip -u services.jar classes.dex
   ```

### Using jadx + manual patching

If you're familiar with smali, you can:
1. Use jadx to understand the logic
2. Use baksmali/smali to make the actual patch
3. This ensures byte-perfect compatibility

## Step 7: Test the Patch

1. Push the patched JAR to your device:
   ```bash
   adb push services.jar /sdcard/
   adb shell su -c "cp /sdcard/services.jar /data/adb/modules/notification-fix/system/framework/"
   ```

2. Reboot and test

## Troubleshooting

### Bootloop after patching
- Your patch may have broken something
- Boot into recovery and delete the module:
  ```bash
  adb shell su -c "rm -rf /data/adb/modules/notification-fix"
  ```

### Notifications still blocked
- You may have patched the wrong function
- Check logcat for clues:
  ```bash
  adb logcat | grep -i "notif"
  ```

### Signature verification failure
- Some ROMs verify system files
- You may need to disable verification or use a different approach

## Alternative Approach: Xposed/LSPosed

If direct patching is too complex, you can use LSPosed with a custom module:

1. Install LSPosed (Zygisk version)
2. Create an Xposed module that hooks `NotificationManagerService`
3. Override the whitelist check to always return true

This is more maintainable across firmware updates but requires LSPosed.

## Notes

- The exact location and implementation of the whitelist may vary between firmware versions
- Always backup your original `services.jar` before patching
- This patch needs to be redone after each firmware update
