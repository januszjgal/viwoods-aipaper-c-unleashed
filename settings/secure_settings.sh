#!/system/bin/sh
# Secure settings modifications for Viwoods AiPaper C
# Run via: adb shell sh /sdcard/secure_settings.sh

echo "Applying secure settings..."

# === LOCKSCREEN & NOTIFICATIONS ===
# Don't disable lockscreen (0=enabled)
settings put secure lockscreen.disabled 0

# Show notifications on lockscreen
settings put secure lock_screen_show_notifications 1

# Show private notification content on lockscreen
settings put secure lock_screen_allow_private_notifications 1

# Enable swipe from bottom to open notification shade
settings put secure swipe_bottom_to_notification_enabled 1

# === AMBIENT DISPLAY (DOZE) ===
# Enable ambient display/doze
settings put secure doze_enabled 1

# Always-on display (shows time/notifications when screen off)
settings put secure doze_always_on 1

# Wake on double tap
settings put secure doze_pulse_on_double_tap 1

# Wake on pick up
settings put secure doze_pulse_on_pick_up 1

# === NAVIGATION ===
# Use gesture navigation (2=gestures, 0=3-button, 1=2-button)
settings put secure navigation_mode 2

# Show navigation bar
settings put secure navigation_bar_visible 1

echo "Secure settings applied!"
