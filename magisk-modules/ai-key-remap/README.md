# AI Key Remap Module

This Magisk module repurposes the dedicated AI KEY hardware button on the Viwoods AiPaper C to toggle the frontlight instead of launching the Viwoods AI assistant app.

## How It Works

1. **Keylayout Override**: The `AI_KEY.kl` file remaps the hardware key (Linux keycode 59 / KEY_F1) to `UNKNOWN`, preventing Android from handling it
2. **Service Script**: A background service monitors `/dev/input/event6` for the raw key press using `getevent`
3. **Frontlight Toggle**: When pressed, it toggles between frontlight off (0) and minimal brightness (1)

## Installation

1. Copy this folder to `/data/adb/modules/ai_key_remap/`
2. Ensure proper permissions:
   ```bash
   chmod 755 /data/adb/modules/ai_key_remap/service.sh
   chmod 644 /data/adb/modules/ai_key_remap/module.prop
   chmod 644 /data/adb/modules/ai_key_remap/system/usr/keylayout/AI_KEY.kl
   ```
3. Reboot

## Files

- `module.prop` - Module metadata
- `service.sh` - Background service that handles key press
- `auto_mount` - Empty file that enables auto-mounting of system overlay
- `system/usr/keylayout/AI_KEY.kl` - Keylayout override

## Customization

To change the frontlight brightness levels, edit the `toggle_frontlight()` function in `service.sh`. The Viwoods e-ink display has separate warm and cold frontlight channels controlled via:
- `settings system screen_brightness_warm` (0-255)
- `settings system screen_brightness_cold` (0-255)
