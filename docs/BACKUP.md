# Backup Guide

Always backup your device before making modifications. This guide covers what and how to backup.

## What to Backup

### Critical Partitions
These are essential for recovery:
- `init_boot` - Contains the ramdisk (what Magisk patches)
- `boot` - Kernel and device tree
- `vbmeta` - Verified boot metadata

### Recommended Partitions
Good to have for full recovery:
- `vendor_boot` - Vendor-specific boot resources
- `dtbo` - Device tree overlays

### User Data
- App data and settings
- Internal storage files

## Backup Commands

### 1. Backup Boot Partitions

```bash
# Create backup directory
mkdir viwoods_backup
cd viwoods_backup

# Check current slot
adb shell getprop ro.boot.slot_suffix
# Assume _b for this example

# Backup init_boot (critical - what Magisk patches)
adb shell su -c "dd if=/dev/block/by-name/init_boot_b of=/sdcard/init_boot_b.img"
adb pull /sdcard/init_boot_b.img

# Backup boot partition
adb shell su -c "dd if=/dev/block/by-name/boot_b of=/sdcard/boot_b.img"
adb pull /sdcard/boot_b.img

# Backup vendor_boot
adb shell su -c "dd if=/dev/block/by-name/vendor_boot_b of=/sdcard/vendor_boot_b.img"
adb pull /sdcard/vendor_boot_b.img

# Backup vbmeta
adb shell su -c "dd if=/dev/block/by-name/vbmeta_b of=/sdcard/vbmeta_b.img"
adb pull /sdcard/vbmeta_b.img

# Backup dtbo
adb shell su -c "dd if=/dev/block/by-name/dtbo_b of=/sdcard/dtbo_b.img"
adb pull /sdcard/dtbo_b.img
```

### 2. Backup Magisk Data

If you already have Magisk installed:

```bash
# Backup Magisk modules
adb shell su -c "tar -cvf /sdcard/magisk_modules.tar /data/adb/modules"
adb pull /sdcard/magisk_modules.tar

# Backup service scripts
adb shell su -c "tar -cvf /sdcard/magisk_service.tar /data/adb/service.d"
adb pull /sdcard/magisk_service.tar

# Backup post-fs-data scripts
adb shell su -c "tar -cvf /sdcard/magisk_post-fs.tar /data/adb/post-fs-data.d"
adb pull /sdcard/magisk_post-fs.tar
```

### 3. Backup App Data

```bash
# Full ADB backup (requires user confirmation on device)
adb backup -apk -shared -all -f viwoods_full_backup.ab

# Or backup specific apps
adb backup -apk -f signal_backup.ab org.thoughtcrime.securesms
```

### 4. Backup Settings

```bash
# Dump all settings for reference
adb shell settings list global > settings_global.txt
adb shell settings list secure > settings_secure.txt
adb shell settings list system > settings_system.txt
```

### 5. Backup Internal Storage

```bash
# Pull entire internal storage (can be large)
adb pull /sdcard/ ./sdcard_backup/

# Or just important folders
adb pull /sdcard/DCIM ./backup/DCIM
adb pull /sdcard/Download ./backup/Download
adb pull /sdcard/Documents ./backup/Documents
```

## Quick Backup Script

Save this as `backup.sh` and run on your computer:

```bash
#!/bin/bash
# Viwoods AiPaper C Backup Script

BACKUP_DIR="viwoods_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cd "$BACKUP_DIR"

echo "Starting backup..."

# Get slot
SLOT=$(adb shell getprop ro.boot.slot_suffix | tr -d '\r')
echo "Current slot: $SLOT"

# Backup partitions
echo "Backing up partitions..."
for part in init_boot boot vendor_boot vbmeta dtbo; do
    echo "  - ${part}${SLOT}"
    adb shell su -c "dd if=/dev/block/by-name/${part}${SLOT} of=/sdcard/${part}.img" 2>/dev/null
    adb pull /sdcard/${part}.img 2>/dev/null
    adb shell rm /sdcard/${part}.img 2>/dev/null
done

# Backup Magisk data
echo "Backing up Magisk data..."
adb shell su -c "tar -cvf /sdcard/magisk_data.tar /data/adb/" 2>/dev/null
adb pull /sdcard/magisk_data.tar 2>/dev/null
adb shell rm /sdcard/magisk_data.tar 2>/dev/null

# Backup settings
echo "Backing up settings..."
adb shell settings list global > settings_global.txt
adb shell settings list secure > settings_secure.txt
adb shell settings list system > settings_system.txt

# Device info
echo "Saving device info..."
adb shell getprop > device_props.txt

echo ""
echo "Backup complete! Files saved to: $BACKUP_DIR"
ls -la
```

## Restore Commands

### Restore Boot Partitions

```bash
# DANGER: Only restore if you know what you're doing

# Restore init_boot
adb push init_boot_b.img /sdcard/
adb shell su -c "dd if=/sdcard/init_boot_b.img of=/dev/block/by-name/init_boot_b"

# Restore boot
adb push boot_b.img /sdcard/
adb shell su -c "dd if=/sdcard/boot_b.img of=/dev/block/by-name/boot_b"

# Reboot
adb reboot
```

### Restore Magisk Modules

```bash
adb push magisk_modules.tar /sdcard/
adb shell su -c "cd / && tar -xvf /sdcard/magisk_modules.tar"
adb reboot
```

### Restore ADB Backup

```bash
adb restore viwoods_full_backup.ab
```

## Storage Requirements

Approximate backup sizes:
| Item | Size |
|------|------|
| init_boot | ~64 MB |
| boot | ~64 MB |
| vendor_boot | ~64 MB |
| vbmeta | ~8 KB |
| dtbo | ~8 MB |
| Magisk data | ~50-500 MB |
| Full internal storage | Varies |

**Recommended**: At least 1 GB free on computer for partition backups.

## Best Practices

1. **Backup before every modification** - Create a new backup before installing new modules or making changes
2. **Label your backups** - Include date and description (e.g., `init_boot_b_20260204_before_magisk.img`)
3. **Store backups safely** - Keep copies on multiple devices/cloud storage
4. **Test restores** - Occasionally verify your backups can be restored
5. **Document changes** - Keep notes of what modifications you've made

## Emergency Recovery

If your device bootloops and you can't access it:

1. **Wait** - A/B devices may automatically switch to the other slot
2. **Try fastboot** - If bootloader is accessible:
   ```bash
   adb reboot bootloader
   fastboot flash init_boot_b init_boot_b.img
   fastboot reboot
   ```
3. **Factory reset** - Boot to recovery and wipe data (last resort)
4. **MTK tools** - Use MediaTek-specific tools for low-level recovery
