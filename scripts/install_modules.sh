#!/system/bin/sh
# Install Magisk modules from repository
# Run as root: su -c 'sh /sdcard/viwoods-unleashed/scripts/install_modules.sh'

REPO_DIR="/sdcard/viwoods-unleashed"

echo "Installing Magisk modules..."

# AI Key Remap
if [ -d "$REPO_DIR/magisk-modules/ai-key-remap" ]; then
    echo "Installing AI Key Remap..."
    mkdir -p /data/adb/modules/ai_key_remap/system/usr/keylayout
    cp "$REPO_DIR/magisk-modules/ai-key-remap/module.prop" /data/adb/modules/ai_key_remap/
    cp "$REPO_DIR/magisk-modules/ai-key-remap/service.sh" /data/adb/modules/ai_key_remap/
    cp "$REPO_DIR/magisk-modules/ai-key-remap/system/usr/keylayout/AI_KEY.kl" \
       /data/adb/modules/ai_key_remap/system/usr/keylayout/
    touch /data/adb/modules/ai_key_remap/auto_mount
    chmod 755 /data/adb/modules/ai_key_remap/service.sh
    echo "  Done!"
fi

echo ""
echo "Note: notification-fix and android-auto-system require manual setup."
echo "See their respective README files for instructions."
echo ""
echo "Reboot for changes to take effect."
