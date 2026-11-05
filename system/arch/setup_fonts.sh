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
print_section "Installing Fonts"

declare -a fonts=(
  #  BitstreamVeraSansMono
  CascadiaCode
  # CodeNewRoman
  # DroidSansMono
  FiraCode
  FiraMono
  # Go-Mono
  # Hack
  # Hermit
  JetBrainsMono
  Meslo
  # Noto
  # Overpass
  # ProggyClean
  # RobotoMono
  SourceCodePro
  # SpaceMono
  # Ubuntu
  # UbuntuMono
)

#==================================
# Font Dependencies
#==================================
# Installed here as well, so this step works no matter what ran before it
print_title "Font Dependencies"
pacman_install "curl" "curl"
pacman_install "unzip" "unzip"
pacman_install "fontconfig" "fontconfig"

#==================================
# Nerd Fonts (latest release)
#==================================
print_title "Nerd Fonts"
for font in "${fonts[@]}"; do
  install_nerd_font "$font"
done

update_font_cache
