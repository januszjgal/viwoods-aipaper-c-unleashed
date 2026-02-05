#!/system/bin/sh
# Viwoods AiPaper C Unleashed - Master Setup Script
# Run via: adb push scripts/setup.sh /sdcard/ && adb shell sh /sdcard/setup.sh
#
# Prerequisites:
# - Device must be rooted with Magisk
# - All repo files must be pushed to /sdcard/viwoods-unleashed/

REPO_DIR="/sdcard/viwoods-unleashed"
LOG_TAG="ViwoodsSetup"

log() {
    echo "[Setup] $1"
    log -t $LOG_TAG "$1" 2>/dev/null
}

check_root() {
    if [ "$(id -u)" != "0" ]; then
        log "ERROR: This script must be run as root"
        log "Run: su -c 'sh $0'"
        exit 1
    fi
}

check_magisk() {
    if [ ! -d "/data/adb/magisk" ]; then
        log "ERROR: Magisk not found. Please root your device first."
        log "See docs/ROOTING.md for instructions."
        exit 1
    fi
    log "Magisk detected: $(magisk -v 2>/dev/null || echo 'version unknown')"
}

install_boot_scripts() {
    log "Installing boot scripts..."

    mkdir -p /data/adb/service.d

    for script in disable_doze.sh notification_wake.sh notif-fix.sh; do
        if [ -f "$REPO_DIR/boot-scripts/$script" ]; then
            cp "$REPO_DIR/boot-scripts/$script" /data/adb/service.d/
            chmod 755 /data/adb/service.d/$script
            log "  Installed: $script"
        else
            log "  WARNING: $script not found"
        fi
    done
}

install_ai_key_remap() {
    log "Installing AI Key Remap module..."

    MODULE_DIR="/data/adb/modules/ai_key_remap"
    mkdir -p "$MODULE_DIR/system/usr/keylayout"

    if [ -d "$REPO_DIR/magisk-modules/ai-key-remap" ]; then
        cp "$REPO_DIR/magisk-modules/ai-key-remap/module.prop" "$MODULE_DIR/"
        cp "$REPO_DIR/magisk-modules/ai-key-remap/service.sh" "$MODULE_DIR/"
        touch "$MODULE_DIR/auto_mount"

        if [ -f "$REPO_DIR/magisk-modules/ai-key-remap/system/usr/keylayout/AI_KEY.kl" ]; then
            cp "$REPO_DIR/magisk-modules/ai-key-remap/system/usr/keylayout/AI_KEY.kl" \
               "$MODULE_DIR/system/usr/keylayout/"
        fi

        chmod 755 "$MODULE_DIR/service.sh"
        chmod 644 "$MODULE_DIR/module.prop"
        chmod 644 "$MODULE_DIR/system/usr/keylayout/AI_KEY.kl" 2>/dev/null

        log "  AI Key Remap module installed"
    else
        log "  WARNING: AI Key Remap module not found"
    fi
}

apply_settings() {
    log "Applying settings..."

    # Global settings
    settings put global wifi_sleep_policy 0
    settings put global mobile_data_always_on 1
    settings put global app_standby_enabled 0
    settings put global adaptive_battery_management_enabled 0
    settings put global heads_up_notifications_enabled 1
    settings put global stay_on_while_plugged_in 7
    settings put global window_animation_scale 0.0
    settings put global transition_animation_scale 0.0
    settings put global animator_duration_scale 0.0

    # Secure settings
    settings put secure lockscreen.disabled 0
    settings put secure lock_screen_show_notifications 1
    settings put secure lock_screen_allow_private_notifications 1
    settings put secure swipe_bottom_to_notification_enabled 1
    settings put secure doze_enabled 1
    settings put secure doze_always_on 1
    settings put secure doze_pulse_on_pick_up 1

    # System settings
    settings put system screen_brightness_mode 0
    settings put system dim_screen 0

    log "  Settings applied"
}

disable_doze_now() {
    log "Disabling Doze immediately..."
    dumpsys deviceidle disable 2>/dev/null
    log "  Doze disabled"
}

print_summary() {
    echo ""
    echo "=========================================="
    echo "  Viwoods AiPaper C Unleashed - Complete!"
    echo "=========================================="
    echo ""
    echo "Installed:"
    echo "  - Boot scripts (disable_doze, notification_wake)"
    echo "  - AI Key Remap module"
    echo "  - Optimized settings"
    echo ""
    echo "NOT installed (manual setup required):"
    echo "  - notification-fix (needs patched services.jar)"
    echo "  - android-auto-system (needs APK files)"
    echo ""
    echo "See README.md for detailed instructions."
    echo ""
    echo "REBOOT REQUIRED for all changes to take effect!"
    echo ""
    read -p "Reboot now? (y/N) " answer
    case "$answer" in
        [Yy]* ) reboot;;
        * ) echo "Please reboot manually when ready.";;
    esac
}

# Main execution
echo ""
echo "=========================================="
echo "  Viwoods AiPaper C Unleashed Setup"
echo "=========================================="
echo ""

check_root
check_magisk

log "Starting setup..."
log "Repository: $REPO_DIR"

if [ ! -d "$REPO_DIR" ]; then
    log "ERROR: Repository not found at $REPO_DIR"
    log "Please push the repo first:"
    log "  adb push . /sdcard/viwoods-unleashed/"
    exit 1
fi

install_boot_scripts
install_ai_key_remap
apply_settings
disable_doze_now

print_summary
