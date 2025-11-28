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
  linux-headers
)

# Additional Wayland tools
WAYLAND_TOOLS=(
  waybar
  mako
  grim
  slurp
  satty
  wl-clipboard
  cliphist
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
  inxi            # System information for debug
  expac           # Package information for debug
  docker          # For containerized databases
  docker-compose  # For containerized databases
  libfido2        # For FIDO2 authentication
  pam-u2f         # For FIDO2 authentication
  fprintd         # For fingerprint authentication
  usbutils        # For fingerprint hardware detection
  freerdp         # For Windows VM RDP client
  openbsd-netcat  # For Windows VM network checks
  xdg-utils       # For xdg-terminal-exec
)

# TUI apps for system management (none available in official repos)
TUI_APPS=(
  # bluetui, impala, wiremix are AUR packages - installed separately below
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
  alacritty
  nautilus
  gnome-calculator
  imv
  mpv
  htop
  btop           # System monitor TUI
  neovim
  dust           # Disk usage analyzer
  base-devel     # Required for building AUR packages
  git            # Required for AUR
  cargo          # Required for some AUR packages
  gtk4           # Required for walker
  gtk4-layer-shell  # Required for walker
  protobuf       # Required for walker
)

# AUR packages (installed separately with AUR helper)
AUR_PACKAGES=(
  walker-bin     # App launcher
  wayfreeze-git  # Screen freeze utility
  bluetui        # Bluetooth TUI
  impala         # WiFi/Network TUI
  wiremix        # Audio mixer TUI
  lazydocker     # Docker TUI manager
  asdcontrol-git # Apple display brightness control
  visual-studio-code-bin # VSCode
  python-terminaltexteffects # For screensaver
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

# Install AUR helper (yay) if not already installed
echo ""
if ! command -v yay &> /dev/null; then
  echo "Installing yay (AUR helper)..."
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ~
  echo "yay installed successfully"
else
  echo "yay is already installed"
fi

# Install AUR packages
echo ""
echo "Installing AUR packages..."
echo "The following AUR packages will be installed:"
printf '%s\n' "${AUR_PACKAGES[@]}"
echo ""
read -p "Install AUR packages? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
  for pkg in "${AUR_PACKAGES[@]}"; do
    echo "Installing $pkg..."
    yay -S --needed --noconfirm "$pkg" || echo "Warning: Failed to install $pkg (continuing...)"
  done
  echo "AUR packages installation complete"
else
  echo "Skipping AUR packages installation"
  echo "You can install them manually later with: yay -S ${AUR_PACKAGES[*]}"
fi

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
cp -r config/waybar/* ~/.config/waybar/
cp -r config/waybar/indicators/* ~/.config/waybar/indicators/


# Copy themes
mkdir -p ~/.config/hypr/themes
cp themes/*.conf ~/.config/hypr/themes/

# Set default theme
ln -sf ~/.config/hypr/themes/catppuccin.conf ~/.config/hypr/theme.conf

# Copy bin scripts
if compgen -G "bin/*" > /dev/null; then
  cp bin/* ~/.local/bin/
  chmod +x ~/.local/bin/*
fi

# Copy snapshot scripts
if compgen -G "scripts/*" > /dev/null; then
  cp scripts/* ~/.local/bin/
  chmod +x ~/.local/bin/snapshot-*
fi

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
  # Add fish_add_path to fish config if not already there
  if ! grep -q "fish_add_path ~/.local/bin" ~/.config/fish/config.fish 2>/dev/null; then
    echo "" >> ~/.config/fish/config.fish
    echo "# Add ~/.local/bin to PATH" >> ~/.config/fish/config.fish
    echo "fish_add_path ~/.local/bin" >> ~/.config/fish/config.fish
  fi
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

# Note: split-monitor-workspaces plugin is disabled by default
# If you want per-monitor independent workspaces, uncomment the plugin in hyprland.conf
# and install it with: hyprpm add https://github.com/Duckonaut/split-monitor-workspaces

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
echo "  - Dual-monitor workspace support (1-5 on monitor 1, a-e/6-10 on monitor 2)"
echo "  - Scratchpad workspace (SUPER+S)"
echo "  - Webapp system with launch-or-focus (chromium-based)"
echo "  - BTRFS snapshots with snapper"
echo "  - Enhanced theme system (14 built-in + git theme support)"
echo "  - Screenshot & screen recording tools"
echo "  - TUI system management (Bluetooth, WiFi, Audio) - AUR packages"
echo "  - Walker app launcher - AUR package"
echo "  - Wayfreeze screen freeze - AUR package"
echo "  - Bash & Fish shell configurations"
echo "  - 60+ utility scripts for system management"
echo "  - yay AUR helper for package management"
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
echo "To start Hyprland, select 'Hyprland (uwsm-managed)' or similar from your display manager (Ly)."
echo ""
echo "Enjoy your new setup!"
