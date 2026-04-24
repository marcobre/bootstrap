#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_ubuntu.sh"

#==================================
# Print Section Title
#==================================
print_section "Setting Up Window Manager (Hyprland)"

#==================================
# Install Hyprland
#==================================
print_title "Install Hyprland & Wayland Utilities"

# Add Hyprland PPA
apt_add_repo "Hyprland (cppiber)" "ppa:cppiber/hyprland"

# Update APT
apt_update

# Install Core Hyprland Packages
apt_install "Hyprland" "hyprland"
apt_install "Hyprpaper (Wallpaper)" "hyprpaper"
apt_install "Hyprlock (Screen Locker)" "hyprlock"
apt_install "Hypridle (Idle Daemon)" "hypridle"
apt_install "Hyprpicker (Color Picker)" "hyprpicker"
apt_install "XDG Desktop Portal Hyprland" "xdg-desktop-portal-hyprland"

# Install Recommended Wayland Utilities
apt_install "Waybar (Status Bar)" "waybar"
apt_install "Wofi (App Launcher)" "wofi"
apt_install "Sway Notification Center" "swaync"
apt_install "Grim (Screenshot Utility)" "grim"
apt_install "Slurp (Region Selector)" "slurp"
apt_install "Cliphist (Clipboard Manager)" "cliphist"
apt_install "Wl-clipboard" "wl-clipboard"
apt_install "Brightnessctl" "brightnessctl"
apt_install "Playerctl" "playerctl"

print_success "Hyprland and Wayland utilities installed successfully!"
