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

# Disable WiFi suspend optimizations (prevents WiFi from sleeping on screen off)
settings put global wifi_suspend_optimizations_enabled 0

# Disable WiFi power save mode
settings put global wifi_power_save 0

# Always request WiFi connection
settings put global wifi_always_requested 1

# Force WiFi high-performance mode (disables power saving at framework level)
# Wait for WiFi service to be fully ready
sleep 5
cmd wifi force-hi-perf-mode enabled
cmd wifi force-low-latency-mode enabled

# Disable Viwoods-specific sleep flags (these actually control WiFi/data disable on screen off)
settings put system persist_wifi_sleep_flag 0
settings put system persist_data_sleep_flag 0
settings put system persist_bt_sleep_flag 0
settings put system background_power_saving_enable 0

# Set system property to disable WiFi sleep delay
setprop persist.wifi.sleep.delay.ms -1

# NOTE: WiFi keep-alive daemon is in separate wifi_keepalive.sh script

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
