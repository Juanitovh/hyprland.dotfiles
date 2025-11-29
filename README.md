# Hyprland Dotfiles for Arch Linux

A comprehensive, standalone Hyprland configuration with 60+ utility scripts, advanced theming, dual-monitor workspace management, and TUI system management tools. Built for Arch Linux with zero external dependencies.

![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-blue)
![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

### Core Capabilities
- **Dynamic Tiling Window Manager** - Advanced window management with grouping, scratchpad, and smart tiling
- **Dual Monitor Support** - Traditional workspace numbering (1-5 on monitor 1, a-e/6-10 on monitor 2)
- **Webapp System** - Launch websites as standalone apps with launch-or-focus functionality
- **14 Built-in Themes** - Plus support for installing custom themes from Git repositories
- **BTRFS Snapshots** - System state management with Snapper integration
- **Shell Configurations** - Rich Bash and Fish configurations with modern CLI tools
- **60+ Utility Scripts** - Complete system management from the command line

### Window Management
- **Scratchpad workspace** - Quick-access terminal with SUPER+S
- **Window grouping** - Tab-like containers for organized workflow
- **Launch-or-focus** - Prevents duplicate windows, focuses existing instances
- **Smart keybindings** - Extensive keyboard-driven workflow
- **Cross-monitor movement** - Easy window transfer between displays

### System Management
- **TUI Apps** - Bluetooth (bluetui), WiFi (impala), Audio (wiremix)
- **Package Management** - Interactive fzf-based package browser
- **Font Management** - System-wide font switching with live reload
- **Hardware Utilities** - Battery status, drive management, device info
- **Update Management** - System and firmware updates with hooks

### Theming
- **14 Built-in Themes**: Catppuccin, Nord, Gruvbox, Dracula, Tokyo Night, and more
- **Git Theme Installation**: `hypr-theme-install https://github.com/user/theme-repo`
- **Theme Cycling**: Quick switching with `hypr-theme-next`
- **Hook System**: Execute custom scripts on theme changes
- **Waybar Integration**: Auto-updating status bar with custom workspace labels

## Quick Start

### Installation

```bash
git clone https://github.com/yourusername/hyprland-dotfiles.git
cd hyprland-dotfiles
./install.sh
```

The installer will:
1. Install 70+ packages (Hyprland, Waybar, utilities)
2. Copy configurations to `~/.config/`
3. Install utility scripts to `~/.local/bin/`
4. Set up shell configurations (Bash + Fish)
5. Configure BTRFS snapshots with Snapper
6. Install default webapps (GitHub, ChatGPT, YouTube)

### Requirements

- Arch Linux (or Arch-based distribution)
- BTRFS filesystem (recommended for snapshots)
- At least 2GB free disk space
- Internet connection for package installation

### First Launch

After installation, start Hyprland:

```bash
Hyprland
```

Or select "Hyprland" from your display manager.

## Keybindings

### Essential

| Keybinding | Action |
|------------|--------|
| `SUPER + ENTER` | Launch terminal |
| `SUPER + SPACE` | App launcher |
| `SUPER + ALT + SPACE` | Settings menu |
| `SUPER + ESC` | System menu (lock/suspend/shutdown) |
| `SUPER + K` | Show keybindings help |
| `SUPER + Q` | Close window |

### Window Management

| Keybinding | Action |
|------------|--------|
| `SUPER + H/J/K/L` | Move focus left/down/up/right |
| `SUPER + SHIFT + H/J/K/L` | Move window left/down/up/right |
| `SUPER + S` | Toggle scratchpad |
| `SUPER + G` | Toggle window grouping |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + P` | Pin window (show on all workspaces) |

### Workspaces

| Keybinding | Action |
|------------|--------|
| `SUPER + 1-5` | Switch to workspace 1-5 (monitor 1) |
| `SUPER + 6-0` | Switch to workspace 6-10 (monitor 2) |
| `SUPER + SHIFT + 1-0` | Move window to workspace |
| `SUPER + Mouse Scroll` | Cycle workspaces |
| `CTRL + SHIFT + LEFT/RIGHT` | Move window between monitors |
| `CTRL + SHIFT + UP/DOWN` | Move window to next/prev workspace and follow |

### Utilities

| Keybinding | Action |
|------------|--------|
| `SUPER + CTRL + V` | Clipboard manager |
| `PRINT` | Screenshot area |
| `SUPER + PRINT` | Screenshot full screen |
| `CTRL + PRINT` | Start screen recording |

## Utility Scripts

All scripts are prefixed with `hypr-` and installed to `~/.local/bin/`.

### Theme Management

```bash
hypr-theme-install <git-url>  # Install theme from Git repository
hypr-theme-set <name>          # Change active theme
hypr-theme-list                # List all available themes
hypr-theme-next                # Cycle to next theme
hypr-theme-current             # Show current theme
hypr-theme-remove <name>       # Remove custom theme
hypr-theme-update              # Update Git-installed themes
```

**Example:**
```bash
# Install a custom theme
hypr-theme-install https://github.com/bjarneo/omarchy-ash-theme

# Apply it
hypr-theme-set ash

# Or cycle through themes
hypr-theme-next
```

### Application Management

```bash
hypr-app-viewer                # Browse all installed applications
hypr-webapp-install            # Install website as app
hypr-webapp-remove             # Remove webapp
hypr-launch-browser            # Launch default browser
hypr-launch-editor             # Launch default editor
hypr-launch-terminal           # Launch default terminal
```

**Example:**
```bash
# Install Discord as a webapp
hypr-webapp-install "Discord" "https://discord.com" "https://cdn.icon-url.png"

# Browse all apps
hypr-app-viewer
```

### System Management

```bash
hypr-update-system             # Update packages (pacman + AUR)
hypr-update-firmware           # Update firmware with fwupd
hypr-battery-status            # Show battery percentage
hypr-battery-remaining         # Show time remaining
hypr-font-set <name>           # Change system font
hypr-font-list                 # List available fonts
```

### Hardware Control

```bash
hypr-launch-bluetooth          # Bluetooth TUI (bluetui)
hypr-launch-wifi               # WiFi TUI (impala)
hypr-launch-audio              # Audio TUI (wiremix)
hypr-audio-switch              # Switch audio output
hypr-restart-bluetooth         # Restart Bluetooth service
hypr-restart-wifi              # Restart WiFi
hypr-restart-pipewire          # Restart audio
```

### Window & Workspace Management

```bash
hypr-toggle-idle               # Toggle idle/lock timer
hypr-toggle-nightlight         # Toggle warm screen temperature
hypr-toggle-screensaver        # Toggle screensaver
hypr-toggle-waybar             # Toggle status bar
hypr-workspace-toggle-gaps     # Toggle window gaps
hypr-window-close-all          # Close all windows in workspace
```

### System Restart/Refresh

```bash
hypr-restart-waybar            # Restart status bar
hypr-restart-walker            # Restart app launcher
hypr-restart-hypridle          # Restart idle daemon
hypr-refresh-hyprland          # Reload Hyprland config
hypr-refresh-waybar            # Reload Waybar
```

### Package Management

```bash
hypr-pkg-install               # Interactive package installer
hypr-pkg-aur-install           # Install AUR packages
hypr-pkg-remove                # Remove packages
hypr-pkg-search                # Search packages
```

### Snapshots (BTRFS)

```bash
snapshot-create                # Create system snapshot
snapshot-restore               # Restore from snapshot
snapshot-list                  # List all snapshots
```

## Shell Configurations

### Bash (`~/.config/bash/hyprland.bashrc`)

**Aliases:**
- `ls` → `eza -lh --group-directories-first --icons=auto` (modern ls)
- `lsa` → `ls -a` (show hidden files)
- `lt` → `eza --tree` (tree view)
- `cd` → `zd` (zoxide smart cd)
- `g` → `git`
- `gcm` → `git commit -m`
- `gcam` → `git commit -a -m`

**Functions:**
- `compress <folder>` - Create tar.gz archive
- `decompress <archive>` - Extract archive
- `img2jpg <image>` - Convert image to JPG
- `transcode-video-1080p <video>` - Transcode to 1080p
- `iso2sd <iso> <device>` - Burn ISO to USB

### Fish (`~/.config/fish/hyprland.fish`)

**Features:**
- Starship prompt integration
- fzf fuzzy search
- Git log aliases
- Lazy conda loading
- Alt-Backspace for path component deletion

**Aliases:**
- `vi` → `nvim`
- `ssk` → `kitty +kitten ssh`

## Directory Structure

```
~/.config/
├── hypr/                      # Hyprland configuration
│   ├── hyprland.conf         # Main config
│   ├── monitors.conf         # Monitor setup
│   ├── bindings/             # Keybindings
│   ├── themes/               # Built-in themes
│   └── apps/                 # App-specific rules
├── hypr-themes/              # Custom Git-installed themes
├── waybar/                   # Status bar config
├── bash/                     # Bash configuration
│   └── hyprland.bashrc
└── fish/                     # Fish configuration
    └── hyprland.fish

~/.local/
├── bin/                      # Utility scripts (60+)
│   ├── hypr-*               # All Hyprland utilities
│   └── snapshot-*           # Snapshot management
├── share/applications/       # Desktop entries
└── state/hyprland/          # State management
    ├── toggles/             # Feature toggles
    ├── current/             # Active theme/config
    ├── hooks/               # Event hooks
    └── themes/              # Theme metadata
```

## Built-in Themes

1. **catppuccin** - Catppuccin Mocha (soothing pastel)
2. **nord** - Nord (arctic, bluish)
3. **gruvbox** - Gruvbox Dark (retro groove)
4. **dracula** - Dracula (dark with vibrant colors)
5. **tokyo-night** - Tokyo Night (dark purple-blue)
6. **rose-pine** - Rosé Pine (natural pine, faux fur, and a bit of soho vibes)
7. **onedark** - One Dark (Atom editor inspired)
8. **monokai** - Monokai Pro (colorful on dark)
9. **solarized-dark** - Solarized Dark (precision colors)
10. **everforest** - Everforest Dark (green forest theme)
11. **kanagawa** - Kanagawa (inspired by famous painting)
12. **nightfox** - Nightfox (vibrant dark theme)
13. **tokyonight-storm** - Tokyo Night Storm variant
14. **nord-aurora** - Nord Aurora (with more colors)

## Advanced Configuration

### Custom Keybindings

Edit `~/.config/hypr/bindings/*.conf`:

```conf
# Add custom keybinding
bind = SUPER, X, exec, your-custom-command
```

Then reload: `hypr-refresh-hyprland`

### Theme Customization

Themes can override:
- Colors (background, foreground, accent)
- Window decorations (borders, gaps, rounding)
- Animations
- Blur effects

Create `~/.config/hypr-themes/mytheme/hyprland.conf`:

```conf
general {
    col.active_border = rgb(ff0000)
    col.inactive_border = rgb(666666)
}

decoration {
    rounding = 10
}
```

Apply: `hypr-theme-set mytheme`

### Hooks

Execute custom scripts on events by creating executable files in `~/.local/state/hyprland/hooks/`:

- `theme-set` - Runs after theme change
- `post-update` - Runs after system update
- `font-set` - Runs after font change

**Example hook** (`~/.local/state/hyprland/hooks/theme-set`):
```bash
#!/bin/bash
# Notify when theme changes
notify-send "Theme Changed" "Now using: $1"
```

Make it executable: `chmod +x ~/.local/state/hyprland/hooks/theme-set`

### Webapp Installation

Install any website as a standalone app:

```bash
hypr-webapp-install "App Name" "https://url.com" "https://icon-url.png"
```

The app will:
- Open in a borderless Chromium window
- Use launch-or-focus (won't create duplicates)
- Have a desktop entry for app launcher
- Use the specified icon

### Monitor Configuration

Edit `~/.config/hypr/monitors.conf`:

```conf
# Configure your monitors
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = DP-4, 2560x1440@144, 1920x0, 1

# Assign workspaces
workspace = 1, monitor:eDP-1, default:true
workspace = 6, monitor:DP-4, default:true
```

Find monitor names: `hyprctl monitors`

## Troubleshooting

### Run the troubleshoot script first
```bash
hypr-troubleshoot
```
This will check all components and provide specific fixes.

### SUPER+SPACE shows nothing (walker not working)

**Symptoms:** Pressing SUPER+SPACE shows blank window or "nothing found"

**Fixes:**
```bash
# 1. Check if elephant and walker are installed
which elephant
which walker

# 2. If elephant not installed, install it (REQUIRED for walker to work)
yay -S elephant-desktopapplications-bin elephant-clipboard-bin

# 3. If walker not installed, install it
yay -S walker-bin

# 4. Check if services are running
pgrep -x elephant
pgrep -f "walker --gapplication-service"

# 5. Start elephant service FIRST
setsid uwsm-app -- elephant &
sleep 0.5

# 6. Start walker service
pkill walker
uwsm-app -- walker --gapplication-service &
sleep 1

# 7. Test walker manually
walker

# 8. Reload Hyprland
hyprctl reload
```

**Note:** Elephant is the search backend required by walker. Without elephant running, walker will show "nothing found" even if apps are installed.

### SUPER+CTRL+V doesn't open clipboard (cliphist not working)

**Symptoms:** Clipboard manager doesn't open or shows empty

**Fixes:**
```bash
# 1. Check if cliphist is installed
which cliphist

# 2. If not installed
sudo pacman -S cliphist wl-clipboard

# 3. Start clipboard watcher
pkill wl-paste
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# 4. Test clipboard has history
cliphist list

# 5. If empty, copy something first
echo "test" | wl-copy

# 6. Try clipboard manager
walker -m clipboard
```

### Notifications don't disappear

**Symptoms:** Notifications stay on screen forever and don't auto-dismiss

**Cause:** Mako config is missing or has no default-timeout set

**Fixes:**
```bash
# 1. Copy mako config
mkdir -p ~/.config/mako
cp ~/installation_hyprland/config/mako/config ~/.config/mako/

# 2. Restart mako
pkill mako
setsid uwsm-app -- mako &

# Or use the helper script
hypr-restart-mako

# 3. Test it
notify-send "Test" "This should disappear in 5 seconds"
```

### Waybar not starting
```bash
hypr-restart-waybar
```

### Theme not applying
```bash
hypr-refresh-hyprland
hyprctl reload
```

### Keybindings not working
Check for conflicts:
```bash
hyprctl binds
```

### Missing dependencies
Re-run the installer:
```bash
./install.sh
```

### Snapshots not working
Verify BTRFS filesystem:
```bash
findmnt -n -o FSTYPE /
```

Configure snapper:
```bash
sudo snapper -c root create-config /
```

### Application launcher (elephant) not showing apps

If elephant shows errors like "unterminated string" or "uwsm-app -- ///":

```bash
# Find malformed desktop entries
hypr-fix-desktop-entries

# Check if elephant service is running
systemctl --user status elephant

# Restart elephant
systemctl --user restart elephant

# Check elephant logs
journalctl --user -u elephant -f
```

### Walker not showing apps
```bash
hypr-refresh-walker
```

## Performance Tips

1. **Reduce animations** - Edit `~/.config/hypr/hyprland.conf`:
   ```conf
   animations {
       enabled = yes
       animation = windows, 1, 3, default
       animation = fade, 1, 3, default
   }
   ```

2. **Disable blur** - For lower-end hardware:
   ```conf
   decoration {
       blur {
           enabled = false
       }
   }
   ```

3. **Lower Waybar update frequency** - Edit `~/.config/waybar/config.jsonc`:
   ```json
   "cpu": {
       "interval": 10
   }
   ```

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Credits

- **Hyprland** - [vaxerski](https://github.com/hyprwm/Hyprland)
- **Waybar** - [Alexays](https://github.com/Alexays/Waybar)
- **Walker** - [abenz1267](https://github.com/abenz1267/walker)
- **Themes** - Various community creators
- Inspired by the Omarchy OS project (security-enhanced fork)

## License

MIT License - See LICENSE file for details

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/hyprland-dotfiles/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/hyprland-dotfiles/discussions)
- **Hyprland Wiki**: [wiki.hyprland.org](https://wiki.hyprland.org)

---

**Star this repo** if you find it useful!

Made with ❤️ for the Arch + Hyprland community
