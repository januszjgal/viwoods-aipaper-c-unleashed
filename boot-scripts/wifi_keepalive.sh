#!/system/bin/sh
# Network Keep-Alive Service
# Monitors and re-enables WiFi, mobile data, and Bluetooth if disabled during sleep
# Viwoods firmware kills all radios ~3-4s after screen off; this daemon re-enables them
# BT headphones will briefly disconnect but auto-reconnect within seconds

sleep 60  # Wait for system boot

while true; do
    wifi=$(settings get global wifi_on)
    data=$(settings get global mobile_data)
    bt=$(settings get global bluetooth_on)

    [ "$wifi" = "0" ] && svc wifi enable
    [ "$data" = "0" ] && svc data enable
    [ "$bt" = "0" ] && svc bluetooth enable

    [ "$wifi" = "0" ] || [ "$data" = "0" ] || [ "$bt" = "0" ] && \
        log -t NetworkKeepAlive "Re-enabled radios (wifi=$wifi data=$data bt=$bt)"

    sleep 3
done
