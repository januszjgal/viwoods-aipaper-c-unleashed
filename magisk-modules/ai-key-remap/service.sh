#!/system/bin/sh
# AI Key Remap Service
# Intercepts the hardware AI KEY press and toggles frontlight brightness
# instead of launching the Viwoods AI assistant app

MODDIR=${0%/*}
STATE=/data/adb/ai_key_frontlight_state
EVENT=/dev/input/event6

getv() { settings get system "$1" 2>/dev/null; }
putv() { settings put system "$1" "$2"; }

restore_defaults_if_missing() {
  [ -n "$SAVED_WARM" ] || SAVED_WARM="$(getv def_screen_brightness_warm)"
  [ -n "$SAVED_COLD" ] || SAVED_COLD="$(getv def_screen_brightness_cold)"
  [ -n "$SAVED_WARM" ] || SAVED_WARM=0
  [ -n "$SAVED_COLD" ] || SAVED_COLD=0
}

toggle_frontlight() {
  # Read current warm brightness
  CURRENT_WARM="$(getv screen_brightness_warm)"

  # Toggle between 0 and 1 (minimal frontlight)
  if [ "$CURRENT_WARM" = "0" ] || [ -z "$CURRENT_WARM" ]; then
    # Currently off or unset, turn on to 1
    putv screen_brightness_warm 1
    putv screen_brightness_cold 0
  else
    # Currently on, turn off to 0
    putv screen_brightness_warm 0
    putv screen_brightness_cold 0
  fi
}

# Wait for Android to finish booting
while [ "$(getprop sys.boot_completed 2>/dev/null)" != "1" ]; do
  sleep 2
done

# Listen for the raw key press on the AI KEY input device
getevent -l "$EVENT" 2>/dev/null | while IFS= read -r line; do
  case "$line" in
    *EV_KEY*KEY_F1*DOWN*) toggle_frontlight ;;
  esac
done
