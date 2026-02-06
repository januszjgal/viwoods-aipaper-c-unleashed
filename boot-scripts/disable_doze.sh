#!/system/bin/sh
# Power management and notification fixes for always-on connectivity
# This script runs at boot after services are ready

# Wait for system to be fully ready
sleep 30

# === POWER MANAGEMENT ===
# Disable Doze (deep and light idle) for connectivity
dumpsys deviceidle disable

# Set WiFi sleep policy to NEVER (2). Values: 0=default(sleep), 1=never_while_plugged, 2=never
settings put global wifi_sleep_policy 2

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

# Prevent BT from being powered down during sleep
# WifiSleepController checks this property at boot to decide if BT should sleep
setprop persist.bt.power.down false

# Keep mobile data active
settings put global mobile_data_always_on 1

# Disable app standby and adaptive battery
settings put global app_standby_enabled 0
settings put global adaptive_battery_management_enabled 0

# === NOTIFICATIONS ===
# Disable popup/toast notifications (using widget instead)
settings put global heads_up_notifications_enabled 0
settings put secure doze_enabled 0
settings put secure doze_always_on 0
settings put secure doze_pulse_on_pick_up 0

# Log completion
log -t BootFixes "Power management and notification settings applied"
