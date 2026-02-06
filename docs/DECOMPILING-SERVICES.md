# Decompiling services.jar

How to decompile and analyze the Viwoods firmware's `services.jar` to find and understand system-level behavior.

## Why

The Viwoods AiPaper C has custom code in `services.jar` that controls power management, notifications, and radio sleep. When settings don't work as expected, decompiling reveals the actual logic.

### Known Viwoods-specific classes

| Class | Path | Purpose |
|-------|------|---------|
| `WifiSleepController` | `com.android.server.connectivity` | Disables WiFi, BT, and mobile data on screen off |

## Prerequisites

- ADB with root access
- [jadx](https://github.com/skylot/jadx) for decompilation

### Install jadx

```powershell
# Via scoop
scoop install jadx

# Or download manually
# https://github.com/skylot/jadx/releases
# Extract to C:\jadx
```

## Step 1: Pull services.jar

```bash
adb shell su -c "cp /system/framework/services.jar /data/local/tmp/"
adb pull /data/local/tmp/services.jar
```

## Step 2: Decompile

```bash
jadx --no-res --show-bad-code -d services-decompiled services.jar
```

This takes a few minutes. The `--no-res` flag skips resources (not needed), `--show-bad-code` ensures partial decompilation is still shown.

## Step 3: Search for the relevant code

```bash
# Find Viwoods custom classes
grep -r "viwoods\|WifiSleep\|SleepController" services-decompiled/

# Find specific behavior
grep -r "WifiSleepPowerDown" services-decompiled/
grep -r "persist_wifi_sleep_flag\|persist_bt_sleep_flag" services-decompiled/
```

## Example: WifiSleepController

Found at: `com/android/server/connectivity/WifiSleepController.java`

This class:
1. Listens for `SCREEN_OFF` broadcast
2. Sets an alarm with delay from `persist.wifi.sleep.delay.ms` (default 30s)
3. When alarm fires, disables WiFi, BT, and mobile data
4. On `SCREEN_ON`, re-enables them

### Key settings it checks

| Setting/Property | Type | Controls |
|-----------------|------|----------|
| `wifi_sleep_policy` (global) | `0`=sleep, `1`=sleep unless charging, **`2`=never** | Whether to start sleep timer |
| `persist.bt.power.down` (property) | boolean | Whether BT is included in sleep |
| `persist.wifi.sleep.delay.ms` (property) | int (ms) | Delay before radios are disabled |

### The fix

The `wifi_sleep_policy` setting has **inverted semantics** from standard Android:
- `0` = DEFAULT = **do sleep** (we incorrectly used this thinking it meant "never")
- `2` = NEVER = **don't sleep**

Setting `wifi_sleep_policy` to `2` prevents the sleep timer from being set, keeping all radios alive during screen off.

## Cleanup

The decompiled output (`services-decompiled/`) is ~3000+ files and is gitignored. Delete it when done:

```bash
rm -rf services-decompiled/
```
