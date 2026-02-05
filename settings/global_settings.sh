#!/system/bin/sh
# Global settings modifications for Viwoods AiPaper C
# Run via: adb shell sh /sdcard/global_settings.sh
# Or push to /data/adb/service.d/ and make executable for boot-time application

echo "Applying global settings..."

# === POWER MANAGEMENT ===
# WiFi never sleeps (0=never, 1=only when plugged in, 2=always)
settings put global wifi_sleep_policy 0

# Keep mobile data always on for MMS and background sync
settings put global mobile_data_always_on 1

# Disable app standby (prevents apps from being restricted)
settings put global app_standby_enabled 0

# Disable adaptive battery (prevents aggressive battery optimization)
settings put global adaptive_battery_management_enabled 0

# Stay awake while plugged in (7 = AC + USB + Wireless charging)
settings put global stay_on_while_plugged_in 7

# === NOTIFICATIONS ===
# Enable heads-up notifications
settings put global heads_up_notifications_enabled 1

# === ANIMATIONS ===
# Disable animations for faster e-ink response
settings put global window_animation_scale 0.0
settings put global transition_animation_scale 0.0
settings put global animator_duration_scale 0.0

echo "Global settings applied!"
