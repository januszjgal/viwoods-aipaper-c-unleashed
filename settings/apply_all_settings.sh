#!/system/bin/sh
# Master script to apply all settings
# Run via: adb shell sh /sdcard/apply_all_settings.sh

SCRIPT_DIR=$(dirname "$0")

echo "=========================================="
echo "Viwoods AiPaper C - Applying All Settings"
echo "=========================================="
echo ""

# Apply global settings
echo ">>> Applying global settings..."
sh "$SCRIPT_DIR/global_settings.sh"
echo ""

# Apply secure settings
echo ">>> Applying secure settings..."
sh "$SCRIPT_DIR/secure_settings.sh"
echo ""

# Apply system settings
echo ">>> Applying system settings..."
sh "$SCRIPT_DIR/system_settings.sh"
echo ""

echo "=========================================="
echo "All settings applied successfully!"
echo "=========================================="
echo ""
echo "Note: Some settings may require a reboot to take effect."
