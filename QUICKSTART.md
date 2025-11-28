# Quick Start Guide

## Installation (5 minutes)

```bash
cd installation_hyprland
./install.sh
```

That's it! The script will install everything automatically.

## First Launch

After installation:

1. **Logout** from your current session
2. **Select "Hyprland"** from your display manager
3. **Login** with your credentials

Or start directly from TTY:
```bash
Hyprland
```

## Essential Keybindings (Must Know)

```
SUPER + SPACE           → Open app launcher
SUPER + ALT + SPACE     → Settings menu (audio, wifi, bluetooth, theme)
SUPER + ENTER           → Open terminal
SUPER + W               → Close window
SUPER + ESC             → System menu (lock, shutdown, etc.)
SUPER + K               → Show all keybindings
SUPER + Q               → Exit Hyprland
```

## Window Management Basics

```
SUPER + T           → Float/tile toggle
SUPER + F           → Fullscreen
SUPER + 1-9         → Switch workspace
SUPER + SHIFT + 1-9 → Move window to workspace
ALT + TAB           → Cycle windows
```

## Special Features

### Scratchpad (Hidden Workspace)
```
SUPER + S           → Show/hide scratchpad
SUPER + ALT + S     → Send window to scratchpad
```

### Window Groups (Tabs)
```
SUPER + G           → Create group from selected windows
SUPER + ALT + TAB   → Switch between grouped windows
SUPER + ALT + G     → Remove from group
```

### Screenshots
```
PRINT               → Screenshot with editor
SHIFT + PRINT       → Screenshot to clipboard
```

### Themes
```
SUPER + SHIFT + CTRL + SPACE  → Theme menu
```

Or from terminal:
```bash
hypr-theme-set catppuccin
hypr-theme-set tokyo-night
hypr-theme-set gruvbox
```

## Webapps

Install any website as an app:
```bash
hypr-webapp-install
```

Examples included: GitHub, ChatGPT, YouTube

## Snapshots (BTRFS Only)

Create system backup:
```bash
snapshot-create "Before changes"
```

Restore if something breaks:
```bash
snapshot-restore
```

## Customization

Edit these files:
- `~/.config/hypr/looknfeel.conf` - Colors, gaps, animations
- `~/.config/hypr/monitors.conf` - Monitor setup
- `~/.config/hypr/bindings/tiling.conf` - Keybindings

Reload after changes:
```bash
hyprctl reload
```

## Troubleshooting

### Nothing is working
Did you logout and login to Hyprland?

### App launcher not opening
```bash
pkill walker && walker --gapplication-service &
```

### Can't take screenshots
```bash
sudo pacman -S grim slurp satty
```

### Waybar not showing
```bash
SUPER + SHIFT + SPACE
```

## Getting Help

- Full documentation: See README.md
- Hyprland wiki: https://wiki.hyprland.org
- Arch wiki: https://wiki.archlinux.org

## Next Steps

1. **Add wallpapers** to `~/Pictures/Wallpapers`
2. **Try different themes** with `hypr-theme-set`
3. **Install webapps** for your favorite sites
4. **Customize keybindings** in `~/.config/hypr/bindings/`
5. **Setup snapshots** if on BTRFS

Enjoy your new Hyprland setup!
