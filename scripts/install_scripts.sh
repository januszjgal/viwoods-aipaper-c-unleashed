#!/system/bin/sh
# Install boot service scripts
# Run as root: su -c 'sh /sdcard/viwoods-unleashed/scripts/install_scripts.sh'

REPO_DIR="/sdcard/viwoods-unleashed"
SERVICE_DIR="/data/adb/service.d"

echo "Installing boot service scripts..."

mkdir -p "$SERVICE_DIR"

for script in disable_doze.sh notification_wake.sh notif-fix.sh; do
    if [ -f "$REPO_DIR/boot-scripts/$script" ]; then
        cp "$REPO_DIR/boot-scripts/$script" "$SERVICE_DIR/"
        chmod 755 "$SERVICE_DIR/$script"
        echo "  Installed: $script"
    else
        echo "  Not found: $script"
    fi
done

echo ""
echo "Scripts installed to $SERVICE_DIR"
echo "They will run automatically on next boot."
echo ""
echo "To run immediately without reboot:"
echo "  sh $SERVICE_DIR/disable_doze.sh"
echo "  sh $SERVICE_DIR/notification_wake.sh &"
