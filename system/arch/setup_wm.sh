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

WM="${1:-mangowc}"

case "$WM" in
    mangowc)
        print_title "Install MangoWC"
        yay_install "MangoWC" "mangowc-git"
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
