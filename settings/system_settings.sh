#!/system/bin/sh
# System settings modifications for Viwoods AiPaper C
# Run via: adb shell sh /sdcard/system_settings.sh

echo "Applying system settings..."

# === DISPLAY ===
# Disable auto screen brightness
settings put system screen_brightness_mode 0

# Set screen brightness to minimum (e-ink doesn't need brightness)
settings put system screen_brightness 1

# Screen timeout: 3 minutes (180000ms)
# Options: 15000, 30000, 60000, 120000, 180000, 300000, 600000, 1800000, -1 (never)
settings put system screen_off_timeout 180000

# Disable dim screen before timeout
settings put system dim_screen 0

# === SOUND ===
# Enable haptic feedback
settings put system haptic_feedback_enabled 1

# Enable touch sounds
settings put system sound_effects_enabled 1

# === MISC ===
# Show battery percentage in status bar
settings put system status_bar_show_battery_percent 1

# Set font scale to normal (1.0)
settings put system font_scale 1.0

echo "System settings applied!"
