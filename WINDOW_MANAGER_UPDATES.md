# Window Manager Configuration Updates

## Overview
Updated the installation_hyprland package to match the workspace configuration described in `/home/cactus/.config/hypr/window_manager.md`. These changes configure traditional workspace numbering (1-10 across two monitors) instead of using the split-monitor-workspaces plugin.

## Changes Made

### 1. hyprland.conf
**File:** `config/hypr/hyprland.conf`

**Changes:**
- **Disabled** the `split-monitor-workspaces` plugin by commenting it out
- Added instructions for re-enabling if needed

**Reason:** Use traditional workspace numbering (1-10) instead of per-monitor independent workspaces (1-5 per monitor).

```conf
# Disabled split-monitor-workspaces plugin to use traditional workspace numbering
# If you want per-monitor independent workspaces, uncomment this and install the plugin:
# hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
# plugin {
#     split-monitor-workspaces {
#         count = 5
#         keep_focused = 1
#         enable_notifications = 1
#         enable_persistent_workspaces = 1
#     }
# }
```

---

### 2. monitors.conf
**File:** `config/hypr/monitors.conf`

**Changes:**
- Added workspace assignments for two-monitor setup
- Monitor 1 (eDP-1): Workspaces 1-5
- Monitor 2 (DP-4): Workspaces 6-10 (labeled a-e in Waybar)
- All workspaces set as `persistent:true`

```conf
# Laptop monitor (eDP-1) gets workspaces 1-5
workspace = 1, monitor:eDP-1, default:true, persistent:true
workspace = 2, monitor:eDP-1, persistent:true
workspace = 3, monitor:eDP-1, persistent:true
workspace = 4, monitor:eDP-1, persistent:true
workspace = 5, monitor:eDP-1, persistent:true

# External monitor (DP-4) gets workspaces 6-10 (will display as a-e)
workspace = 6, monitor:DP-4, default:true, persistent:true
workspace = 7, monitor:DP-4, persistent:true
workspace = 8, monitor:DP-4, persistent:true
workspace = 9, monitor:DP-4, persistent:true
workspace = 10, monitor:DP-4, persistent:true
```

**Note:** Users need to customize `eDP-1` and `DP-4` to match their actual monitor names.

---

### 3. bindings/tiling.conf
**File:** `config/hypr/bindings/tiling.conf`

**New Keybindings Added:**

**Move windows between monitors:**
```conf
bindd = CTRL SHIFT, LEFT, Move window to left monitor, movewindow, mon:l
bindd = CTRL SHIFT, RIGHT, Move window to right monitor, movewindow, mon:r
```

**Move window to next/prev workspace and follow:**
```conf
bindd = CTRL SHIFT, UP, Move window to next workspace and follow, exec, hyprctl dispatch movetoworkspace e+1
bindd = CTRL SHIFT, DOWN, Move window to prev workspace and follow, exec, hyprctl dispatch movetoworkspace e-1
```

**Workspace switching:**
- SUPER + 1-5: Switch to workspaces 1-5 (Monitor 1)
- SUPER + 6-0: Switch to workspaces 6-10 (Monitor 2, displayed as a-e)

**Move windows to workspaces:**
- SUPER + SHIFT + 1-5: Move window to workspaces 1-5
- SUPER + SHIFT + 6-0: Move window to workspaces 6-10

---

### 4. waybar/config.jsonc
**File:** `config/waybar/config.jsonc` (newly added)

**Changes:**
- Copied from user's configuration
- Updated Omarchy-specific references to hypr equivalents
- Workspace labels configured:
  - Workspaces 1-5: "1", "2", "3", "4", "5"
  - Workspaces 6-10: "a", "b", "c", "d", "e"
  - Active workspace indicator: "󱓻"
- Persistent workspaces configured for both monitors

```jsonc
"hyprland/workspaces": {
  "on-click": "activate",
  "format": "{icon}",
  "format-icons": {
    "1": "1", "2": "2", "3": "3", "4": "4", "5": "5",
    "6": "a", "7": "b", "8": "c", "9": "d", "10": "e",
    "active": "󱓻",
    "default": ""
  },
  "persistent-workspaces": {
    "eDP-1": [1, 2, 3, 4, 5],
    "DP-4": [6, 7, 8, 9, 10]
  }
}
```

**Omarchy references updated:**
- `custom/omarchy` → `custom/hyprland`
- `omarchy-menu` → `hypr-menu`
- `omarchy-update-available` → `echo ""`
- `omarchy-launch-floating-terminal-with-presentation omarchy-update` → `hypr-update-system`

---

### 5. waybar/style.css
**File:** `config/waybar/style.css` (newly added)

**Changes:**
- Copied from user's configuration to maintain consistent styling

---

### 6. install.sh
**File:** `install.sh`

**Changes:**
- Added waybar configuration installation step

```bash
# Copy waybar config
mkdir -p ~/.config/waybar
cp config/waybar/* ~/.config/waybar/
```

---

## Keybindings Summary

### Window Movement Between Monitors
- **Ctrl + Shift + Left**: Move window to left monitor
- **Ctrl + Shift + Right**: Move window to right monitor

### Window Movement Between Workspaces
- **Ctrl + Shift + Up**: Move window to next workspace and follow
- **Ctrl + Shift + Down**: Move window to previous workspace and follow

### Workspace Switching
**Monitor 1 (eDP-1):**
- **Super + 1-5**: Switch to workspaces 1-5

**Monitor 2 (DP-4):**
- **Super + 6**: Switch to workspace 6 (displayed as "a")
- **Super + 7**: Switch to workspace 7 (displayed as "b")
- **Super + 8**: Switch to workspace 8 (displayed as "c")
- **Super + 9**: Switch to workspace 9 (displayed as "d")
- **Super + 0**: Switch to workspace 10 (displayed as "e")

### Moving Windows to Workspaces
- **Super + Shift + 1-5**: Move window to workspaces 1-5
- **Super + Shift + 6-0**: Move window to workspaces 6-10

---

## Monitor Setup

- **eDP-1** (Laptop): Workspaces 1, 2, 3, 4, 5
- **DP-4** (External): Workspaces 6, 7, 8, 9, 10 (labeled a, b, c, d, e)

**Note:** Users need to identify their monitor names using:
```bash
hyprctl monitors
```

Then update `monitors.conf` to match their actual monitor names.

---

## Troubleshooting

If workspaces appear on the wrong monitor after a Hyprland reload:

```bash
for i in 6 7 8 9 10; do hyprctl dispatch workspace $i && hyprctl dispatch moveworkspacetomonitor $i DP-4; done && hyprctl dispatch workspace 1
```

Replace `DP-4` with your actual external monitor name.

---

## Migration from split-monitor-workspaces

If you previously used the split-monitor-workspaces plugin:

1. The plugin is now commented out in `hyprland.conf`
2. Workspace numbering changed from per-monitor (1-5, 1-5) to global (1-10)
3. External monitor workspaces now display as letters (a-e) in Waybar
4. All workspace keybindings remain the same (SUPER + 1-0)

To revert to split-monitor-workspaces:
1. Uncomment the plugin block in `hyprland.conf`
2. Run: `hyprpm add https://github.com/Duckonaut/split-monitor-workspaces`
3. Remove workspace assignments from `monitors.conf`
4. Update Waybar config to remove persistent-workspaces

---

## Files Modified

1. `config/hypr/hyprland.conf` - Disabled plugin
2. `config/hypr/monitors.conf` - Added workspace assignments
3. `config/hypr/bindings/tiling.conf` - Added new keybindings
4. `config/waybar/config.jsonc` - Added with custom labels
5. `config/waybar/style.css` - Added styling
6. `install.sh` - Added waybar installation step
