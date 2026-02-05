# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2026-02-04

### Added
- Initial release
- AI Key Remap module - repurposes hardware AI button to toggle frontlight
- Boot scripts:
  - `disable_doze.sh` - Disables aggressive power management
  - `notification_wake.sh` - Wakes screen briefly on notification
  - `notif-fix.sh` - Mounts patched services.jar
- Documentation:
  - Rooting guide for A/B devices with init_boot
  - Backup and restore procedures
  - Troubleshooting guide
  - Reverting instructions
- Settings scripts for optimal e-ink configuration
- Master setup script for easy installation
- Recommended apps list for e-ink displays

### Device Compatibility
- Tested on: Viwoods AiPaper Reader C
- Android: 16 (API 36)
- Firmware: SE08C_V_1.1.0
- Magisk: 30.6

### Notes
- `notification-fix` module requires user to patch their own `services.jar`
- `android-auto-system` module requires user to supply their own APK
- Stock firmware backup not included
