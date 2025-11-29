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
  swaybg
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
  elephant-desktopapplications-bin  # Desktop app search backend
  elephant-clipboard-bin      # Clipboard history backend
  elephant-menus-bin          # Menu provider for theme selection
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

# Setup elephant service
# Use elephant's built-in service management (creates systemd service automatically)
echo "Setting up elephant service..."
if command -v elephant &> /dev/null; then
  elephant service enable 2>/dev/null || true
  systemctl --user start elephant.service 2>/dev/null || true
  echo "Elephant service configured"
else
  echo "WARNING: elephant not installed. Service setup will be skipped."
  echo "Install elephant providers with: yay -S elephant-desktopapplications-bin elephant-clipboard-bin"
fi


# Copy configuration files
echo ""
echo "Installing configuration files..."

# Create necessary directories
mkdir -p ~/.config/hypr/{apps,bindings}
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications/icons

# Copy application .desktop files
mkdir -p ~/.local/share/applications
cp applications/*.desktop ~/.local/share/applications/

# Copy UWSM environment config
mkdir -p ~/.config/uwsm
cp config/uwsm/env ~/.config/uwsm/

# Copy elephant config
mkdir -p ~/.config/elephant/menus
cp config/elephant/*.toml ~/.config/elephant/
cp config/elephant/menus/*.lua ~/.config/elephant/menus/

# Copy walker config
mkdir -p ~/.config/walker/themes
cp config/walker/config.toml ~/.config/walker/
if [ -d "config/walker/themes" ]; then
  cp -r config/walker/themes/* ~/.config/walker/themes/
fi

# Mako config will be symlinked from theme (see theme setup section below)
# mkdir -p ~/.config/mako
# cp config/mako/config ~/.config/mako/

# Copy swayosd config
mkdir -p ~/.config/swayosd
cp config/swayosd/* ~/.config/swayosd/

# Copy Hyprland configs
cp -r config/hypr/* ~/.config/hypr/

# Copy waybar config
mkdir -p ~/.config/waybar
cp -r config/waybar/* ~/.config/waybar/
cp -r config/waybar/indicators/* ~/.config/waybar/indicators/

# Copy terminal configs (Alacritty, Kitty, Ghostty)
mkdir -p ~/.config/alacritty
cp config/alacritty.toml ~/.config/alacritty/alacritty.toml

mkdir -p ~/.config/kitty
cp config/kitty/kitty.conf ~/.config/kitty/kitty.conf

mkdir -p ~/.config/ghostty
cp config/ghostty/config ~/.config/ghostty/config

# Copy themes (now full theme directories with all config files)
mkdir -p ~/.config/hypr/themes
cp -r themes/* ~/.config/hypr/themes/

# Set default theme (catppuccin) and create symlinks
mkdir -p ~/.local/state/hyprland/current
ln -snf ~/.config/hypr/themes/catppuccin ~/.local/state/hyprland/current/theme
ln -snf ~/.local/state/hyprland/current/theme/hyprland.conf ~/.config/hypr/theme.conf

# Create application-specific symlinks for btop and mako
mkdir -p ~/.config/btop/themes
ln -snf ~/.local/state/hyprland/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/mako
ln -snf ~/.local/state/hyprland/current/theme/mako.ini ~/.config/mako/config

# Set initial background
echo "Setting up initial wallpaper..."
if [ -d ~/.local/state/hyprland/current/theme/backgrounds ]; then
  # Use mapfile to get backgrounds array (same as Omarchy)
  mapfile -d '' -t BACKGROUNDS < <(find -L ~/.local/state/hyprland/current/theme/backgrounds -type f -print0 2>/dev/null | sort -z)
  if [ ${#BACKGROUNDS[@]} -gt 0 ]; then
    echo "Found ${#BACKGROUNDS[@]} background(s), setting first one: ${BACKGROUNDS[0]}"
    ln -snf "${BACKGROUNDS[0]}" ~/.local/state/hyprland/current/background
  else
    echo "WARNING: No background images found in theme"
  fi
else
  echo "WARNING: Background directory not found at ~/.local/state/hyprland/current/theme/backgrounds"
fi

# Create browser policy directories if chromium or brave are installed
if command -v chromium &>/dev/null; then
  sudo mkdir -p /etc/chromium/policies/managed 2>/dev/null || true
  sudo chmod a+rw /etc/chromium/policies/managed 2>/dev/null || true
fi

if command -v brave &>/dev/null; then
  sudo mkdir -p /etc/brave/policies/managed 2>/dev/null || true
  sudo chmod a+rw /etc/brave/policies/managed 2>/dev/null || true
fi

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
  if ! grep -q "hyprland.bashrc" ~/.bashrc 2>/dev/null;
  then
    echo "" >> ~/.bashrc
    echo "# Hyprland configuration" >> ~/.bashrc
    echo "[ -f ~/.config/bash/hyprland.bashrc ] && source ~/.config/bash/hyprland.bashrc" >> ~/.bashrc
  fi
fi

if [ -f config/fish/hyprland.fish ]; then
  cp config/fish/hyprland.fish ~/.config/fish/
  # Add fish_add_path to fish config if not already there
  if ! grep -q "fish_add_path ~/.local/bin" ~/.config/fish/config.fish 2>/dev/null;
  then
    echo "" >> ~/.config/fish/config.fish
    echo "# Add ~/.local/bin to PATH" >> ~/.config/fish/config.fish
    echo "fish_add_path ~/.local/bin" >> ~/.config/fish/config.fish
  fi
  # Add sourcing to fish config if not already there
  mkdir -p ~/.config/fish
  if [ ! -f ~/.config/fish/config.fish ] || ! grep -q "hyprland.fish" ~/.config/fish/config.fish 2>/dev/null;
  then
    echo "" >> ~/.config/fish/config.fish
    echo "# Hyprland configuration" >> ~/.config/fish/config.fish
    echo "test -f ~/.config/fish/hyprland.fish; and source ~/.config/fish/hyprland.fish" >> ~/.config/fish/config.fish
  fi
fi

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != ":$HOME/.local/bin:"* ]]; then
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

# Start walker service for app launcher
echo ""
echo "Starting walker service..."
if command -v walker &> /dev/null; then
  # Kill any existing walker instances
  pkill walker 2>/dev/null || true

  # Start walker as a background service with uwsm-app for proper session management
  setsid uwsm-app -- walker --gapplication-service &
  sleep 1
  echo "Walker service started"
else
  echo "WARNING: walker not installed. App launcher (SUPER+SPACE) will not work."
  echo "Install with: yay -S walker-bin"
fi

# Restart mako notification daemon
echo ""
echo "Restarting mako notification daemon..."
if command -v mako &> /dev/null; then
  pkill mako 2>/dev/null || true
  setsid uwsm-app -- mako &
  sleep 0.5
  echo "Mako restarted with new config"
else
  echo "WARNING: mako not installed. Notifications will not work."
fi

# Restart elephant service if installed
echo ""
echo "Setting up elephant service..."
if command -v elephant &> /dev/null; then
  systemctl --user daemon-reload
  systemctl --user restart elephant.service 2>/dev/null || true
  systemctl --user enable elephant.service 2>/dev/null || true
  echo "Elephant service configured"
else
  echo "WARNING: elephant not installed. Theme menu may not work."
  echo "Elephant is optional - install manually if needed"
fi

# Enable services
echo ""
echo "Enabling system services..."
sudo systemctl enable bluetooth
sudo systemctl enable NetworkManager

# Setup Limine bootloader with snapper snapshot menu
echo ""
echo "Configuring boot menu with snapshot support..."
if command -v limine &>/dev/null; then
  # Install limine snapper integration packages
  sudo pacman -S --noconfirm --needed limine-snapper-sync limine-mkinitcpio-hook

  # Configure mkinitcpio hooks
  sudo tee /etc/mkinitcpio.conf.d/hyprland_hooks.conf <<'EOF' >/dev/null
HOOKS=(base udev plymouth keyboard autodetect microcode modconf kms keymap consolefont block encrypt filesystems fsck btrfs-overlayfs)
EOF

  # Detect if using EFI or BIOS
  [[ -f /boot/EFI/limine/limine.conf ]] || [[ -f /boot/EFI/BOOT/limine.conf ]] && EFI=true

  # Find limine config location
  if [[ -n "$EFI" ]]; then
    if [[ -f /boot/EFI/BOOT/limine.conf ]]; then
      limine_config="/boot/EFI/BOOT/limine.conf"
    else
      limine_config="/boot/EFI/limine/limine.conf"
    fi
  else
    limine_config="/boot/limine/limine.conf"
  fi

  # Get current kernel command line
  if [[ -f "$limine_config" ]]; then
    CMDLINE=$(grep "^[[:space:]]*cmdline:" "$limine_config" | head -1 | sed 's/^[[:space:]]*cmdline:[[:space:]]*//')
  else
    echo "Warning: Limine config not found, using default cmdline"
    CMDLINE="rw"
  fi

  # Create limine configuration
  sudo tee /etc/default/limine <<EOF >/dev/null
TARGET_OS_NAME="Hyprland"

ESP_PATH="/boot"

KERNEL_CMDLINE[default]="$CMDLINE"
KERNEL_CMDLINE[default]+="quiet splash"

ENABLE_UKI=yes
CUSTOM_UKI_NAME="hyprland"

ENABLE_LIMINE_FALLBACK=yes

# Find and add other bootloaders
FIND_BOOTLOADERS=yes

BOOT_ORDER="*, *fallback, Snapshots"

MAX_SNAPSHOT_ENTRIES=5

SNAPSHOT_FORMAT_CHOICE=5
EOF

  # Disable UKI and fallback for BIOS systems
  if [[ -z $EFI ]]; then
    sudo sed -i '/^ENABLE_UKI=/d; /^ENABLE_LIMINE_FALLBACK=/d' /etc/default/limine
  fi

  # Create limine boot menu configuration
  sudo tee /boot/limine.conf <<'EOF' >/dev/null
### Read more at config document: https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md
#timeout: 3
default_entry: 2
interface_branding: Hyprland Bootloader
interface_branding_color: 2
hash_mismatch_panic: no

term_background: 1a1b26
backdrop: 1a1b26

# Terminal colors (Tokyo Night palette)
term_palette: 15161e;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;a9b1d6
term_palette_bright: 414868;f7768e;9ece6a;e0af68;7aa2f7;bb9af7;7dcfff;c0caf5

# Text colors
term_foreground: c0caf5
term_foreground_bright: c0caf5
term_background_bright: 24283b

EOF

  # Remove old config if it's not /boot/limine.conf
  if [[ "$limine_config" != "/boot/limine.conf" ]] && [[ -f "$limine_config" ]]; then
    sudo rm "$limine_config"
  fi

  # Configure snapper
  if ! sudo snapper list-configs 2>/dev/null | grep -q "root"; then
    sudo snapper -c root create-config /
  fi

  if ! sudo snapper list-configs 2>/dev/null | grep -q "home"; then
    sudo snapper -c home create-config /home
  fi

  # Tweak snapper settings
  sudo sed -i 's/^TIMELINE_CREATE="yes"/TIMELINE_CREATE="no"/' /etc/snapper/configs/{root,home} 2>/dev/null || true
  sudo sed -i 's/^NUMBER_LIMIT="50"/NUMBER_LIMIT="5"/' /etc/snapper/configs/{root,home} 2>/dev/null || true
  sudo sed -i 's/^NUMBER_LIMIT_IMPORTANT="10"/NUMBER_LIMIT_IMPORTANT="5"/' /etc/snapper/configs/{root,home} 2>/dev/null || true

  # Enable limine-snapper-sync service
  sudo systemctl enable limine-snapper-sync.service

  # Re-enable mkinitcpio hooks
  if [ -f /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled ]; then
    sudo mv /usr/share/libalpm/hooks/90-mkinitcpio-install.hook.disabled /usr/share/libalpm/hooks/90-mkinitcpio-install.hook
  fi

  if [ -f /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled ]; then
    sudo mv /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook.disabled /usr/share/libalpm/hooks/60-mkinitcpio-remove.hook
  fi

  # Update limine bootloader
  echo "Updating bootloader..."
  sudo limine-update

  echo "Boot menu with snapshots configured successfully!"
else
  echo "Warning: Limine bootloader not found. Skipping snapshot boot menu setup."
  echo "If you want snapshot boot menu, install limine bootloader first."
fi

# Create default wallpaper directory
mkdir -p ~/Pictures/Wallpapers
echo "Created wallpaper directory at ~/Pictures/Wallpapers"

# Install default webapps
echo ""
echo "Installing default webapps..."
~/.local/bin/hypr-webapp-install "GitHub" "https://github.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github-light.png" || echo "Warning: GitHub webapp icon download failed, using fallback"
~/.local/bin/hypr-webapp-install "ChatGPT" "https://chatgpt.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/chatgpt.png" || echo "Warning: ChatGPT webapp icon download failed, using fallback"
~/.local/bin/hypr-webapp-install "YouTube" "https://youtube.com" "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/youtube.png" || echo "Warning: YouTube webapp icon download failed, using fallback"

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
echo "Troubleshooting:"
echo "  If SUPER+SPACE shows no apps:"
echo "    1. Check walker is running: pgrep walker"
echo "    2. Restart walker: pkill walker && uwsm-app -- walker --gapplication-service &"
echo "    3. Test manually: walker"
echo ""
echo "  If theme menu shows 'waiting for elephant':"
echo "    1. Check elephant is installed: which elephant"
echo "    2. Test manually: elephant -m hyprthemes"
echo "    3. Check for Lua errors: journalctl --user -u elephant"
echo ""
echo "Enjoy your new setup!"