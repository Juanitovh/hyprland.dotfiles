#!/bin/bash

set -e

echo "==================================="
echo "Hyprland Installation Script"
echo "Standalone setup (no Omarchy deps)"
echo "==================================="
echo ""

# Check if running on Arch Linux
if [ ! -f /etc/arch-release ]; then
  echo "Error: This script is designed for Arch Linux"
  exit 1
fi

# Check if running as root
if [ "$EUID" -eq 0 ]; then
  echo "Error: Do not run this script as root"
  exit 1
fi

# Install dependencies
echo "Installing packages..."
echo "This will install Hyprland, Waybar, and all necessary tools"
echo ""

# Core Hyprland packages
CORE_PACKAGES=(
  hyprland
  hyprlock
  hypridle
  hyprsunset
  hyprpaper
  xdg-desktop-portal-hyprland
  uwsm
)

# Additional Wayland tools
WAYLAND_TOOLS=(
  waybar
  mako
  walker
  grim
  slurp
  satty
  wl-clipboard
  cliphist
  wayfreeze
  wf-recorder
  swww
  swayosd
)

# Core utilities
UTILITIES=(
  chromium
  jq              # JSON processor for launch-or-focus
  gum             # Interactive prompts for theme install
  fzf             # Fuzzy finder for package management TUI
  eza             # Modern ls replacement (for bash aliases)
  zoxide          # Smart cd (for bash)
  starship        # Shell prompt (for fish)
  imagemagick     # Image conversion (img2jpg functions)
  ffmpeg          # Video transcoding functions
  bat             # Better cat with syntax highlighting
  playerctl
  brightnessctl
  pamixer
  upower
  pipewire
  wireplumber
  pipewire-pulse
  pipewire-alsa
  bluez
  bluez-utils
  networkmanager
  network-manager-applet
  xmlstarlet      # XML manipulation for fontconfig
)

# TUI apps for system management
TUI_APPS=(
  bluetui      # Bluetooth TUI
  impala       # WiFi/Network TUI
  wiremix      # Audio mixer TUI
)

# Snapshot tools (BTRFS)
SNAPSHOT_TOOLS=(
  snapper
  snap-pac
  grub-btrfs
)

# Fonts
FONTS=(
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  noto-fonts
  noto-fonts-emoji
)

# Optional but recommended
OPTIONAL=(
  kitty
  nautilus
  gnome-calculator
  imv
  mpv
  htop
  btop           # System monitor TUI
  neovim
  lazydocker     # Docker TUI manager
  dust           # Disk usage analyzer
  yay            # AUR helper for package management
)

ALL_PACKAGES=(
  "${CORE_PACKAGES[@]}"
  "${WAYLAND_TOOLS[@]}"
  "${UTILITIES[@]}"
  "${TUI_APPS[@]}"
  "${SNAPSHOT_TOOLS[@]}"
  "${FONTS[@]}"
  "${OPTIONAL[@]}"
)

echo "The following packages will be installed:"
printf '%s\n' "${ALL_PACKAGES[@]}" | column
echo ""
read -p "Continue with installation? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation cancelled"
  exit 0
fi

# Update system first
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install packages
echo "Installing packages..."
sudo pacman -S --needed --noconfirm "${ALL_PACKAGES[@]}"

# Copy configuration files
echo ""
echo "Installing configuration files..."

# Create necessary directories
mkdir -p ~/.config/hypr/{apps,bindings}
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications/icons

# Copy Hyprland configs
cp -r config/hypr/* ~/.config/hypr/

# Copy waybar config
mkdir -p ~/.config/waybar
cp config/waybar/* ~/.config/waybar/

# Copy themes
mkdir -p ~/.config/hypr/themes
cp themes/*.conf ~/.config/hypr/themes/

# Set default theme
ln -sf ~/.config/hypr/themes/catppuccin.conf ~/.config/hypr/theme.conf

# Copy bin scripts
cp bin/* ~/.local/bin/
chmod +x ~/.local/bin/*

# Copy snapshot scripts
cp scripts/* ~/.local/bin/
chmod +x ~/.local/bin/snapshot-*

# Copy shell configurations
echo "Installing shell configurations..."
mkdir -p ~/.config/bash ~/.config/fish

if [ -f config/bash/hyprland.bashrc ]; then
  cp config/bash/hyprland.bashrc ~/.config/bash/
  # Add sourcing to ~/.bashrc if not already there
  if ! grep -q "hyprland.bashrc" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# Hyprland configuration" >> ~/.bashrc
    echo "[ -f ~/.config/bash/hyprland.bashrc ] && source ~/.config/bash/hyprland.bashrc" >> ~/.bashrc
  fi
fi

if [ -f config/fish/hyprland.fish ]; then
  cp config/fish/hyprland.fish ~/.config/fish/
  # Add sourcing to fish config if not already there
  mkdir -p ~/.config/fish
  if [ ! -f ~/.config/fish/config.fish ] || ! grep -q "hyprland.fish" ~/.config/fish/config.fish 2>/dev/null; then
    echo "" >> ~/.config/fish/config.fish
    echo "# Hyprland configuration" >> ~/.config/fish/config.fish
    echo "test -f ~/.config/fish/hyprland.fish; and source ~/.config/fish/hyprland.fish" >> ~/.config/fish/config.fish
  fi
fi

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Create state directories for hyprland
echo "Creating state directories..."
mkdir -p ~/.local/state/hyprland/{toggles,migrations,current,hooks,themes}

# Install Hyprland plugin: split-monitor-workspaces
echo ""
echo "Installing split-monitor-workspaces plugin..."
echo "This allows independent workspaces per monitor"
if command -v hyprpm >/dev/null; then
  hyprpm add https://github.com/Duckonaut/split-monitor-workspaces
  hyprpm enable split-monitor-workspaces
  echo "Plugin installed successfully"
else
  echo "WARNING: hyprpm not found. You may need to install the plugin manually later"
  echo "Run: hyprpm add https://github.com/Duckonaut/split-monitor-workspaces"
fi

# Setup snapper for BTRFS snapshots
echo ""
echo "Configuring snapper for BTRFS snapshots..."
if findmnt -n -o FSTYPE / | grep -q btrfs; then
  if ! sudo snapper list-configs | grep -q root; then
    sudo snapper -c root create-config /
    echo "Snapper configured for root filesystem"
  else
    echo "Snapper already configured"
  fi

  # Create initial snapshot
  sudo snapper -c root create --description "Initial snapshot after Hyprland installation"
  echo "Initial snapshot created"
else
  echo "WARNING: Root filesystem is not BTRFS. Snapshots will not be available."
fi

# Enable services
echo ""
echo "Enabling system services..."
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager

# Create default wallpaper directory
mkdir -p ~/Pictures/Wallpapers
echo "Created wallpaper directory at ~/Pictures/Wallpapers"

# Install default webapps
echo ""
echo "Installing default webapps..."
~/.local/bin/hypr-webapp-install "GitHub" "https://github.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png"
~/.local/bin/hypr-webapp-install "ChatGPT" "https://chatgpt.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png"
~/.local/bin/hypr-webapp-install "YouTube" "https://youtube.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png"

echo ""
echo "==================================="
echo "Installation complete!"
echo "==================================="
echo ""
echo "Installed features:"
echo "  - Hyprland window manager with tiling & grouping"
echo "  - Split-monitor-workspaces plugin (independent workspaces per monitor)"
echo "  - Scratchpad workspace (SUPER+S)"
echo "  - Webapp system with launch-or-focus (chromium-based)"
echo "  - BTRFS snapshots with snapper"
echo "  - Enhanced theme system (14 built-in + git theme support)"
echo "  - Screenshot & screen recording tools"
echo "  - TUI system management (Bluetooth, WiFi, Audio)"
echo "  - Bash & Fish shell configurations"
echo "  - 60+ utility scripts for system management"
echo ""
echo "Quick start:"
echo "  SUPER+SPACE        - Launch apps"
echo "  SUPER+ALT+SPACE    - Settings menu"
echo "  SUPER+ESC          - System menu (lock, suspend, shutdown)"
echo "  SUPER+K            - Keybindings help"
echo "  SUPER+ENTER        - Open terminal"
echo "  SUPER+S            - Toggle scratchpad"
echo "  SUPER+G            - Toggle window grouping"
echo "  SUPER+CTRL+V       - Clipboard manager"
echo "  PRINT              - Screenshot"
echo ""
echo "Theme commands:"
echo "  hypr-theme-set <name>      - Change theme"
echo "  hypr-theme-list            - List available themes"
echo "  hypr-theme-install <url>   - Install theme from git"
echo "  hypr-theme-remove <name>   - Remove custom theme"
echo "  hypr-theme-next            - Cycle to next theme"
echo ""
echo "System utilities:"
echo "  hypr-app-viewer        - Browse and manage applications"
echo "  hypr-update-system     - Update all packages"
echo "  hypr-font-set <name>   - Change system font"
echo "  hypr-battery-status    - Show battery percentage"
echo ""
echo "Snapshot commands:"
echo "  snapshot-create   - Create a system snapshot"
echo "  snapshot-restore  - Restore from snapshot"
echo "  snapshot-list     - List all snapshots"
echo ""
echo "To start Hyprland, run: Hyprland"
echo "Or select 'Hyprland' from your display manager"
echo ""
echo "Enjoy your new setup!"
