# Recommended Apps for E-Ink

Apps optimized for or tested to work well on the Viwoods AiPaper C e-ink display.

## Launchers

| App | Notes |
|-----|-------|
| **Smart Launcher** | Has e-ink mode, clean interface, highly customizable |
| Niagara Launcher | Minimal, text-based, great for e-ink |
| KISS Launcher | Lightweight, search-focused |
| Lawnchair | Stock Android feel, customizable |

## Keyboards

| App | Notes |
|-----|-------|
| **FUTO Keyboard** | Privacy-focused, good contrast |
| GBoard | Google's keyboard, works well |
| AnySoftKeyboard | Open source, customizable themes |
| Simple Keyboard | Minimal, lightweight |

## Browsers

| App | Notes |
|-----|-------|
| **Firefox** | Full-featured, reader mode |
| **Mozilla Focus** | Privacy browser, minimal UI |
| Brave | Ad blocking built-in |
| Kiwi Browser | Chrome with extensions |

## Reading Apps

| App | Notes |
|-----|-------|
| **ReadEra** | Best e-book reader, many formats |
| **Libby** | Library e-books and audiobooks |
| Moon+ Reader | Feature-rich, many formats |
| KOReader | Open source, advanced features |
| Pocket | Read-later service |

## Social & Messaging

| App | Notes |
|-----|-------|
| **Signal** | Encrypted messaging |
| WhatsApp | Popular messaging |
| Discord | Community chat |
| Telegram | Feature-rich messaging |

## Email

| App | Notes |
|-----|-------|
| **Proton Mail** | Encrypted email |
| Gmail | Google's email client |
| K-9 Mail | Open source |
| FairEmail | Privacy-focused |

## Password Managers

| App | Notes |
|-----|-------|
| **Proton Pass** | Encrypted, works well as autofill |
| Bitwarden | Open source |
| KeePassDX | Offline, open source |

## Utilities

| App | Notes |
|-----|-------|
| **Notification Widget** | Shows notifications as widget |
| Glimpse | Always-on display (if lockscreen works) |
| Tasker | Automation |
| MacroDroid | Simpler automation |
| SD Maid | Cleanup tool |

## Media

| App | Notes |
|-----|-------|
| **Pocket Casts** | Podcast player |
| YouTube Music | Music streaming |
| Spotify | Music streaming |
| Plex | Media server client |

## Maps & Navigation

| App | Notes |
|-----|-------|
| **Google Maps** | Standard mapping |
| Waze | Community-driven navigation |
| OsmAnd | Offline maps |

## Productivity

| App | Notes |
|-----|-------|
| Google Calendar | Calendar |
| Microsoft To Do | Task management |
| Google Keep | Notes |
| Notion | Notes and databases |

## Cloud Storage

| App | Notes |
|-----|-------|
| **Nextcloud** | Self-hosted cloud |
| Google Drive | Google's cloud storage |
| Proton Drive | Encrypted storage |

## Home Automation

| App | Notes |
|-----|-------|
| **Home Assistant** | Open source home automation |
| Google Home | Google's smart home |

## Photo

| App | Notes |
|-----|-------|
| **Immich** | Self-hosted photo backup |
| Google Photos | Cloud photo backup |

## Fitness

| App | Notes |
|-----|-------|
| Hevy | Workout tracking |

## Settings/Tips for E-Ink

### Enable Dark Mode
E-ink displays refresh better with high contrast. Many apps have dark/night modes.

### Disable Animations
```bash
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0
```

### Use Simple Themes
Avoid gradients, transparencies, and complex backgrounds.

### Reduce Refresh Rate Apps
Some apps constantly redraw, causing e-ink ghosting. Avoid:
- Games with animations
- Apps with auto-scrolling content
- Video players (for extended use)

### App-Specific Settings
Many apps have "reduce animations" or "power saving" modes that work better on e-ink.
