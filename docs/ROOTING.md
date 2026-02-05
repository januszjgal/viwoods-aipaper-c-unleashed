# Rooting the Viwoods AiPaper C

This guide explains how to root the Viwoods AiPaper C using Magisk.

## Prerequisites

- Windows/Mac/Linux computer with ADB installed
- USB cable
- Viwoods AiPaper C with USB debugging enabled
- [Magisk app](https://github.com/topjohnwu/Magisk/releases) (APK)

## Device Information

The AiPaper C runs Android 16 with:
- A/B partition scheme
- `init_boot` partition (Android 13+ GKI devices)
- `userdebug` build type (easier to root)

## Step 1: Enable USB Debugging

1. Go to **Settings** > **About phone**
2. Tap **Build number** 7 times to enable Developer Options
3. Go to **Settings** > **System** > **Developer options**
4. Enable **USB debugging**
5. Connect to computer and authorize the connection

Verify connection:
```bash
adb devices
# Should show: SCAA4501M00717    device
```

## Step 2: Install Magisk App

```bash
# Download latest Magisk APK from GitHub releases
adb install Magisk-v30.6.apk
```

## Step 3: Identify Current Boot Slot

The AiPaper C uses A/B partitions. You need to patch the active slot:

```bash
adb shell getprop ro.boot.slot_suffix
# Returns: _a or _b
```

## Step 4: Extract init_boot Image

For Android 13+ devices with GKI (Generic Kernel Image), you patch `init_boot` instead of `boot`:

```bash
# If slot is _b:
adb shell su -c "dd if=/dev/block/by-name/init_boot_b of=/sdcard/init_boot.img"

# If slot is _a:
adb shell su -c "dd if=/dev/block/by-name/init_boot_a of=/sdcard/init_boot.img"

# Pull to computer
adb pull /sdcard/init_boot.img
```

> **Note**: If `su` doesn't work yet, you may need to use a temporary root method or extract via recovery mode.

## Step 5: Patch with Magisk

### Option A: Patch on Device

1. Transfer `init_boot.img` back to device:
   ```bash
   adb push init_boot.img /sdcard/
   ```

2. Open Magisk app on the device

3. Tap **Install** > **Select and Patch a File**

4. Select `/sdcard/init_boot.img`

5. Magisk will create `/sdcard/Download/magisk_patched-XXXXX.img`

6. Pull patched image:
   ```bash
   adb pull /sdcard/Download/magisk_patched-*.img magisk_patched.img
   ```

### Option B: Patch on Computer

1. Install Magisk app on an Android emulator or spare device
2. Transfer `init_boot.img` to that device
3. Patch using Magisk app
4. Transfer patched image back to computer

## Step 6: Flash Patched Image

```bash
# Push patched image to device
adb push magisk_patched.img /sdcard/

# Flash to the same slot you extracted from
# If slot is _b:
adb shell su -c "dd if=/sdcard/magisk_patched.img of=/dev/block/by-name/init_boot_b"

# If slot is _a:
adb shell su -c "dd if=/sdcard/magisk_patched.img of=/dev/block/by-name/init_boot_a"
```

## Step 7: Reboot

```bash
adb reboot
```

## Step 8: Verify Root

After reboot:

1. Open Magisk app
2. It should show **Installed** with version number
3. Test root access:
   ```bash
   adb shell su -c "id"
   # Should show: uid=0(root) gid=0(root)
   ```

## Troubleshooting

### Bootloop after flashing
1. Wait for the system to automatically switch to the other slot (A/B devices do this)
2. If it doesn't recover, boot to recovery and factory reset
3. Try again with a fresh init_boot image

### "su: not found"
- Make sure you rebooted after flashing
- Open Magisk app to complete the installation
- Try `adb shell` then run `su` separately

### Magisk app shows "Requires Additional Setup"
- Tap the prompt and follow instructions
- This usually means the app needs to be reinstalled after Magisk installation

### SafetyNet/Play Integrity fails
- Enable **Zygisk** in Magisk settings
- Enable **Enforce DenyList**
- Add Google Play Services and Play Store to DenyList

## First-Time Root (No Existing Root)

If you don't have root access yet to run `dd`, you'll need to:

### Option 1: Use MTK Bypass (MediaTek devices)
The AiPaper C uses a MediaTek chipset. Tools like `mtkclient` may work:
```bash
# Install mtkclient
pip3 install mtkclient

# Read init_boot (device must be in BROM mode)
mtk r init_boot_b init_boot.img
```

### Option 2: Use Fastboot (if unlocked)
```bash
# Reboot to bootloader
adb reboot bootloader

# Flash patched image
fastboot flash init_boot_b magisk_patched.img

# Reboot
fastboot reboot
```

### Option 3: Temporary Root via ADB
The `userdebug` build may allow temporary root:
```bash
adb root
adb shell dd if=/dev/block/by-name/init_boot_b of=/sdcard/init_boot.img
```

## Post-Root Setup

After rooting, proceed with:

1. **Install LSPosed** (optional, for Xposed modules)
2. **Install modules** from this repo
3. **Apply settings** via the included scripts

See the main [README.md](../README.md) for next steps.

## Partition Map Reference

| Partition | Slot A | Slot B |
|-----------|--------|--------|
| init_boot | /dev/block/sdc32 | /dev/block/sdc52 |
| boot | /dev/block/sdc30 | /dev/block/sdc50 |
| vendor_boot | /dev/block/sdc31 | /dev/block/sdc51 |
| vbmeta | /dev/block/sdc9 | /dev/block/sdc12 |
| super (system/vendor) | /dev/block/sdc56 | - |
| userdata | /dev/block/sdc57 | - |
