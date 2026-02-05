#!/system/bin/sh
# Power management and notification fixes for always-on connectivity
# This script runs at boot after services are ready

# Wait for system to be fully ready
sleep 30

# === POWER MANAGEMENT ===
# Disable Doze (deep and light idle) for connectivity
dumpsys deviceidle disable

# Ensure WiFi never sleeps
settings put global wifi_sleep_policy 0

# Keep mobile data active
settings put global mobile_data_always_on 1

# Disable app standby and adaptive battery
settings put global app_standby_enabled 0
settings put global adaptive_battery_management_enabled 0

# === NOTIFICATIONS ===
# Enable swipe to notification shade
settings put secure swipe_bottom_to_notification_enabled 1

# Enable heads-up notifications
settings put global heads_up_notifications_enabled 1

# === LOCKSCREEN ===
# Enable lockscreen with notifications
settings put secure lockscreen.disabled 0
settings put secure lock_screen_show_notifications 1
settings put secure lock_screen_allow_private_notifications 1

# Enable ambient display for notifications
settings put secure doze_enabled 1
settings put secure doze_always_on 1
settings put secure doze_pulse_on_pick_up 1

# Log completion
log -t BootFixes "Power management and notification settings applied"
