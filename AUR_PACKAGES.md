# AUR Packages Information

This installation uses several packages from the AUR (Arch User Repository) that are not available in the official Arch repositories.

## Automatic Installation

The `install.sh` script will automatically:

1. **Install yay** (AUR helper) if not already installed
2. **Prompt you** to install the following AUR packages
3. **Install each package** using yay

## AUR Packages Included

### Essential Tools

**walker-bin** - Application launcher
- Binary version (faster install, no compilation needed)
- Required dependencies: gtk4, gtk4-layer-shell, protobuf
- Used with: `SUPER + SPACE`

**wayfreeze-git** - Screen freeze utility
- Git version from AUR
- Required dependencies: cargo, wayland, libxkbcommon
- Useful for taking screenshots of menus/tooltips
- Can be bound to keybindings for lock-like freeze

### TUI System Management

**bluetui** - Bluetooth TUI manager
- Interactive terminal interface for Bluetooth
- Used with: `hypr-launch-bluetooth` or `SUPER + ALT + SPACE` → Bluetooth

**impala** - WiFi/Network TUI manager
- Interactive terminal interface for NetworkManager
- Used with: `hypr-launch-wifi` or `SUPER + ALT + SPACE` → WiFi

**wiremix** - Audio mixer TUI
- Interactive terminal interface for PipeWire
- Used with: `hypr-launch-audio` or `SUPER + ALT + SPACE` → Audio

### Optional Tools

**lazydocker** - Docker TUI manager
- Interactive terminal interface for Docker
- Only needed if you use Docker

## Manual Installation

If you skip the AUR packages during installation, you can install them manually later:

```bash
# Install all AUR packages
yay -S walker-bin wayfreeze-git bluetui impala wiremix lazydocker

# Or install individually
yay -S walker-bin        # App launcher
yay -S wayfreeze-git     # Screen freeze
yay -S bluetui           # Bluetooth TUI
yay -S impala            # WiFi TUI
yay -S wiremix           # Audio TUI
yay -S lazydocker        # Docker TUI (optional)
```

## Alternative AUR Helpers

If you prefer `paru` or another AUR helper instead of `yay`:

```bash
# Using paru
paru -S walker-bin wayfreeze-git bluetui impala wiremix

# The install.sh will detect if yay is missing and install it
# You can modify the script to use paru instead if desired
```

## Building from Source (Manual)

If you prefer to build manually without an AUR helper:

### walker-bin
```bash
git clone https://aur.archlinux.org/walker-bin.git
cd walker-bin
makepkg -si
```

### wayfreeze-git
```bash
git clone https://aur.archlinux.org/wayfreeze-git.git
cd wayfreeze-git
makepkg -si
```

### bluetui
```bash
git clone https://aur.archlinux.org/bluetui.git
cd bluetui
makepkg -si
```

### impala
```bash
git clone https://aur.archlinux.org/impala.git
cd impala
makepkg -si
```

### wiremix
```bash
git clone https://aur.archlinux.org/wiremix.git
cd wiremix
makepkg -si
```

## Required Dependencies (Official Repos)

These are installed automatically from official repos before AUR packages:

- **base-devel** - Build tools for compiling AUR packages
- **git** - Version control, required for cloning AUR packages
- **cargo** - Rust toolchain (some AUR packages are written in Rust)
- **gtk4** - GTK4 toolkit (required by walker)
- **gtk4-layer-shell** - GTK layer shell library (required by walker)
- **protobuf** - Protocol buffers (required by walker)
- **wayland** - Wayland protocol libraries
- **libxkbcommon** - Keyboard handling library

## Fallback Options

If AUR packages fail to install or you prefer not to use AUR:

### Alternative to walker (App Launcher)
- **rofi-wayland** - `sudo pacman -S rofi-wayland`
- **wofi** - `sudo pacman -S wofi`
- **fuzzel** - `sudo pacman -S fuzzel`

*Note: You'll need to update keybindings in `~/.config/hypr/bindings/utilities.conf`*

### Alternative to TUI apps
- **bluetoothctl** - Built-in (comes with bluez)
- **nmtui** - Built-in (comes with NetworkManager)
- **alsamixer** - `sudo pacman -S alsa-utils`
- **pavucontrol** - `sudo pacman -S pavucontrol` (GUI, not TUI)

### Alternative to wayfreeze
- Not strictly necessary - used for freezing screen to screenshot menus
- Can use `grim` and `slurp` directly for most screenshot needs

## Troubleshooting

### yay installation fails
```bash
# Install yay manually
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### AUR package build fails
```bash
# Check build dependencies
yay -Si package-name

# Install missing dependencies
sudo pacman -S missing-dependency

# Try building again
yay -S package-name
```

### walker-bin fails to start
```bash
# Check if GTK4 dependencies are installed
pacman -Q gtk4 gtk4-layer-shell protobuf

# If missing, install them
sudo pacman -S gtk4 gtk4-layer-shell protobuf

# Reinstall walker-bin
yay -S walker-bin --rebuild
```

### wayfreeze-git compilation errors
```bash
# Ensure Rust/Cargo is up to date
rustup update

# Ensure Wayland dev libraries are installed
sudo pacman -S wayland libxkbcommon

# Try rebuilding
yay -S wayfreeze-git --rebuild
```

## Updating AUR Packages

```bash
# Update all packages including AUR
yay -Syu

# Update only AUR packages
yay -Sua

# Update specific AUR package
yay -S walker-bin
```

## Uninstalling AUR Packages

```bash
# Remove individual packages
yay -R walker-bin
yay -R wayfreeze-git
yay -R bluetui impala wiremix

# Remove with dependencies
yay -Rs walker-bin
```

## Security Note

AUR packages are user-submitted and not officially maintained by Arch Linux. Always:
- Review PKGBUILDs before installing: `yay -Gp package-name`
- Check package comments on AUR website for issues
- Verify package maintainer reputation
- Keep packages updated regularly

## Links

- **AUR Website**: https://aur.archlinux.org/
- **yay GitHub**: https://github.com/Jguer/yay
- **walker GitHub**: https://github.com/abenz1267/walker
- **wayfreeze GitHub**: https://github.com/Jappie3/wayfreeze
- **bluetui AUR**: https://aur.archlinux.org/packages/bluetui
- **impala AUR**: https://aur.archlinux.org/packages/impala
- **wiremix AUR**: https://aur.archlinux.org/packages/wiremix
