#!/system/bin/sh
# Verify Viwoods AiPaper C Unleashed installation
# Run as root: su -c 'sh /sdcard/viwoods-unleashed/scripts/verify_setup.sh'

echo "=========================================="
echo "  Viwoods AiPaper C Unleashed - Verify"
echo "=========================================="
echo ""

# Check root
echo "=== Root Status ==="
if [ "$(id -u)" = "0" ]; then
    echo "Running as root: YES"
else
    echo "Running as root: NO (some checks may fail)"
fi

# Check Magisk
echo ""
echo "=== Magisk ==="
if [ -d "/data/adb/magisk" ]; then
    echo "Magisk installed: YES"
    echo "Version: $(magisk -v 2>/dev/null || echo 'unknown')"
else
    echo "Magisk installed: NO"
fi

# Check modules
echo ""
echo "=== Magisk Modules ==="
for module in ai_key_remap notification-fix notif-fix android-auto-system; do
    if [ -d "/data/adb/modules/$module" ]; then
        echo "$module: INSTALLED"
    else
        echo "$module: not installed"
    fi
done

# Check boot scripts
echo ""
echo "=== Boot Scripts ==="
for script in disable_doze.sh notification_wake.sh notif-fix.sh; do
    if [ -f "/data/adb/service.d/$script" ]; then
        if [ -x "/data/adb/service.d/$script" ]; then
            echo "$script: INSTALLED (executable)"
        else
            echo "$script: installed (NOT executable!)"
        fi
    else
        echo "$script: not installed"
    fi
done

# Check key settings
echo ""
echo "=== Settings ==="
echo "wifi_sleep_policy: $(settings get global wifi_sleep_policy) (expected: 0)"
echo "mobile_data_always_on: $(settings get global mobile_data_always_on) (expected: 1)"
echo "app_standby_enabled: $(settings get global app_standby_enabled) (expected: 0)"
echo "heads_up_notifications_enabled: $(settings get global heads_up_notifications_enabled) (expected: 1)"
echo "doze_always_on: $(settings get secure doze_always_on) (expected: 1)"
echo "lock_screen_show_notifications: $(settings get secure lock_screen_show_notifications) (expected: 1)"

# Check if notification wake is running
echo ""
echo "=== Running Services ==="
if pgrep -f "notification_wake" > /dev/null 2>&1; then
    echo "notification_wake: RUNNING"
else
    echo "notification_wake: not running"
fi

# Check Doze status
echo ""
echo "=== Doze Status ==="
dumpsys deviceidle 2>/dev/null | grep -E "mState|mEnabled" | head -3

echo ""
echo "=========================================="
echo "Verification complete!"
echo "=========================================="
