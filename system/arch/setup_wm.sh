#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_arch.sh"

#==================================
# Print Section Title
#==================================
print_section "Installing Window Manager"

WM="${1:-mangowm}"

case "$WM" in
mangowm)
  print_title "Install MangoWM"
  # MangoWC was renamed to MangoWM; it is in the official repos (extra), no AUR needed
  pacman_install "MangoWM" "mangowm"
  pacman_install "Waybar" "waybar"
  pacman_install "Swaybg" "swaybg"
  print_title "MangoWM configuration"
  symlink ~/.dotfiles/config/mango/config.conf ~/.config/mango/config.conf
  symlink ~/.dotfiles/config/mango/autostart.sh ~/.config/mango/autostart.sh
  ;;
hyprland)
  print_title "Install Hyprland"
  # TODO: Add Hyprland packages
  print_warning "Hyprland installation not yet implemented"
  ;;
niri)
  print_title "Install Niri"
  # TODO: Add Niri packages
  print_warning "Niri installation not yet implemented"
  ;;
esac
