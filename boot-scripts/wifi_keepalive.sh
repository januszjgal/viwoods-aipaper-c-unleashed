#!/system/bin/sh
# Network Keep-Alive Service
# Keeps WiFi and mobile data enabled during sleep

sleep 60  # Wait for system boot

while true; do
    # Check and re-enable WiFi
    wifi_state=$(settings get global wifi_on)
    if [ "$wifi_state" = "0" ]; then
        svc wifi enable
        log -t NetworkKeepAlive "Re-enabled WiFi"
    fi

    # Check and re-enable mobile data
    data_state=$(settings get global mobile_data)
    if [ "$data_state" = "0" ]; then
        svc data enable
        log -t NetworkKeepAlive "Re-enabled mobile data"
    fi

    sleep 10
done
