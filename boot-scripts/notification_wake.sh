#!/system/bin/sh
# Brief screen wake on notification - runs at boot
# Wakes the e-ink display for 3 seconds when a notification arrives
# Useful since the device has no notification LED

export PATH=/system/bin:/system/xbin:$PATH

# Wait for system to be ready
sleep 45

# Kill any existing logcat instances from this script
killall logcat 2>/dev/null
sleep 2

# Monitor for notifications
logcat -c
logcat | while read line; do
    case "$line" in
        *onNotificationPosted*)
            state=$(dumpsys power 2>/dev/null | grep "mWakefulness=Asleep")
            if [ -n "$state" ]; then
                log -t NotifWake "Waking screen for notification"
                input keyevent 224  # KEYCODE_WAKEUP
                sleep 3
                input keyevent 223  # KEYCODE_SLEEP
                log -t NotifWake "Screen back to sleep"
            fi
            ;;
    esac
done &
