# Viwoods AiPaper C Unleashed

Transform your Viwoods AiPaper C e-ink reader into a fully functional Android phone.

## Overview

The Viwoods AiPaper C is an e-ink Android device that ships with heavy customizations that limit its functionality as a general-purpose phone. This repository contains all the modifications needed to:

- **Enable all notifications** (Viwoods blocks non-Viwoods app notifications by default)
- **Keep WiFi/mobile data always on** (stock aggressive power management disconnects when screen off)
- **Remap the AI KEY button** to toggle frontlight instead of launching Viwoods AI
- **Enable Android Auto** as a system app for car connectivity
- **Wake screen briefly on notifications** (since there's no notification LED)

## Device Information

| Property | Value |
|----------|-------|
| Model | AiPaper Reader C |
| Manufacturer | Viwoods |
| Android Version | 16 (API 36) |
| Firmware | SE08C_V_1.1.0 |
| Build | BP2A.250605.031.A3 |
| Architecture | arm64-v8a |
| Partition Scheme | A/B |

## Quick Start

> **Warning**: These modifications require root access and may void your warranty. Always backup your device before proceeding.

1. **Root your device** - Follow [docs/ROOTING.md](docs/ROOTING.md)
2. **Backup everything** - Follow [docs/BACKUP.md](docs/BACKUP.md)
3. **Run the setup script** - `adb push scripts/setup.sh /sdcard/ && adb shell sh /sdcard/setup.sh`

Or install components individually:
- [Magisk Modules](#magisk-modules)
- [Boot Scripts](#boot-scripts)
- [Settings](#settings)

## Repository Structure

```
viwoods-aipaper-c-unleashed/
├── docs/                      # Documentation
│   ├── ROOTING.md            # Rooting guide
│   ├── BACKUP.md             # Backup instructions
│   ├── TROUBLESHOOTING.md    # Common issues
│   └── REVERTING.md          # How to restore stock
│
├── magisk-modules/           # Magisk modules
│   ├── ai-key-remap/         # Remap AI KEY to frontlight toggle
│   ├── android-auto-system/  # Install Android Auto as system app
│   └── notification-fix/     # Remove notification whitelist
│
├── boot-scripts/             # Boot-time scripts (/data/adb/service.d/)
│   ├── disable_doze.sh       # Disable power management restrictions
│   ├── notification_wake.sh  # Wake screen on notification
│   └── notif-fix.sh          # Mount patched services.jar
│
├── settings/                 # Android settings scripts
│   ├── global_settings.sh    # Global settings
│   ├── secure_settings.sh    # Secure settings
│   ├── system_settings.sh    # System settings
│   └── apply_all_settings.sh # Apply all settings
│
├── apps/                     # Recommended apps
│   └── recommended.md        # List of e-ink optimized apps
│
└── scripts/                  # Setup and utility scripts
    ├── setup.sh              # Master setup script
    ├── install_modules.sh    # Install Magisk modules
    ├── install_scripts.sh    # Install boot scripts
    └── verify_setup.sh       # Verify installation
```

## Magisk Modules

### AI Key Remap
Repurposes the dedicated AI KEY button to toggle the e-ink frontlight instead of launching the Viwoods AI assistant.

**Installation:**
```bash
adb push magisk-modules/ai-key-remap /sdcard/
adb shell su -c "cp -r /sdcard/ai-key-remap /data/adb/modules/"
adb shell su -c "chmod 755 /data/adb/modules/ai-key-remap/service.sh"
adb reboot
```

### Notification Fix
Removes the Viwoods notification whitelist that blocks third-party app notifications.

> **Note**: This module requires you to patch `services.jar` yourself. See [magisk-modules/notification-fix/PATCHING.md](magisk-modules/notification-fix/PATCHING.md) for instructions.

### Android Auto System App
Installs Android Auto as a system privileged app for proper car head unit connectivity.

> **Note**: You need to supply your own Android Auto APK. See [magisk-modules/android-auto-system/README.md](magisk-modules/android-auto-system/README.md) for instructions.

## Boot Scripts

Scripts in `/data/adb/service.d/` run at boot after Android services are ready.

| Script | Purpose |
|--------|---------|
| `disable_doze.sh` | Disables Doze, keeps WiFi/mobile data active, enables notification settings |
| `notification_wake.sh` | Wakes screen for 3 seconds when a notification arrives |
| `notif-fix.sh` | Bind mounts the patched services.jar |

**Installation:**
```bash
adb push boot-scripts/*.sh /sdcard/
adb shell su -c "cp /sdcard/*.sh /data/adb/service.d/"
adb shell su -c "chmod 755 /data/adb/service.d/*.sh"
adb reboot
```

## Settings

Modified Android settings for optimal e-ink phone experience:

**Key Changes:**
- WiFi never sleeps
- Mobile data always on
- Disabled Doze/app standby
- Enabled heads-up notifications
- Disabled animations (faster e-ink response)
- Enabled ambient display

**Apply all settings:**
```bash
adb push settings/*.sh /sdcard/
adb shell sh /sdcard/apply_all_settings.sh
```

## Recommended Apps

See [apps/recommended.md](apps/recommended.md) for a list of apps optimized for e-ink displays.

**Highlights:**
- **Launcher**: Smart Launcher (e-ink mode)
- **Keyboard**: FUTO Keyboard
- **Browser**: Firefox / Mozilla Focus
- **Reading**: ReadEra, Libby
- **Password Manager**: Proton Pass

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues and solutions.

## Reverting to Stock

To undo all modifications, see [docs/REVERTING.md](docs/REVERTING.md).

## Contributing

Contributions are welcome! Please:
1. Test changes on your own device first
2. Document any firmware-specific differences
3. Don't include copyrighted files (APKs, patched system files)

## Disclaimer

This project is not affiliated with Viwoods. Modifying your device may:
- Void your warranty
- Cause bootloops or data loss
- Brick your device if done incorrectly

**Proceed at your own risk.** Always backup your device before making modifications.

## License

MIT License - See [LICENSE](LICENSE) for details.
