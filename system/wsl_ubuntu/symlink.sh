#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
 os_name="$(get_os)"

#==================================
# Print Section Title
#==================================
print_section "Creating Symlinks"


#==================================
# Symlink
#==================================

# add hushlogin file
touch ~/.hushlogin

# fish config
print_title "Fish configuration"
symlink ~/.dotfiles/config/fish/config.fish ~/.config/fish/config.fish
symlink ~/.dotfiles/config/fish/export.fish ~/.config/fish/export.fish
symlink ~/.dotfiles/config/fish/bindings.fish ~/.config/fish/bindings.fish

symlink ~/.dotfiles/config/fish/functions/arasaka.fish ~/.config/fish/functions/arasaka.fish
symlink ~/.dotfiles/config/fish/functions/fcd.fish ~/.config/fish/functions/fcd.fish
symlink ~/.dotfiles/config/fish/functions/flushdns.fish ~/.config/fish/functions/flushdns.fish
symlink ~/.dotfiles/config/fish/functions/gi.fish ~/.config/fish/functions/gi.fish
symlink ~/.dotfiles/config/fish/functions/mkcd.fish ~/.config/fish/functions/mkcd.fish
symlink ~/.dotfiles/config/fish/functions/c_prettyping.fish ~/.config/fish/functions/c_prettyping.fish
symlink ~/.dotfiles/config/fish/functions/c_mtr.fish ~/.config/fish/functions/c_mtr.fish
symlink ~/.dotfiles/config/fish/functions/ql.fish ~/.config/fish/functions/ql.fish
symlink ~/.dotfiles/config/fish/functions/sreload.fish ~/.config/fish/functions/sreload.fish
symlink ~/.dotfiles/config/fish/functions/treload.fish ~/.config/fish/functions/treload.fish
symlink ~/.dotfiles/config/fish/functions/supdate.fish ~/.config/fish/functions/supdate.fish
symlink ~/.dotfiles/config/fish/functions/pupdate.fish ~/.config/fish/functions/pupdate.fish

symlink ~/.dotfiles/config/fish/theme/excalith.fish ~/.config/fish/theme/excalith.fish
touch ~/.config/fish/local.fish

# bash config
print_title "Bash configuration"
symlink ~/.dotfiles/config/bash/.bashrc ~/.bashrc
symlink ~/.dotfiles/config/bash/aliases.bash ~/.config/bash/aliases.bash
symlink ~/.dotfiles/config/bash/functions.bash ~/.config/bash/functions.bash
touch ~/.bash.local

# zsh config
print_title "Zsh configuration"
symlink ~/.dotfiles/config/zsh/.zshrc ~/.zshrc
touch ~/.zsh.local

# starship config
print_title "Starship configuration"
symlink ~/.dotfiles/config/starship/starship.toml ~/.config/starship.toml

# git config
print_title "Git configuration"
symlink ~/.dotfiles/config/git/config ~/.config/git/config
symlink ~/.dotfiles/config/git/ignore_global ~/.config/git/ignore_global
touch ~/.config/git/config.local

# neofetch config
print_title "Neofetch configuration"
symlink ~/.dotfiles/config/neofetch/config.conf ~/.config/neofetch/config.conf

# fastfatch config
print_title "Fastfatch configuration"
symlink ~/.dotfiles/config/fastfatch/config.conf ~/.config/fastfatch/config.conf

# midnight commander theme
print_title "Midnight Commander configuration"
symlink ~/.dotfiles/config/mc/ini ~/.config/mc/ini
symlink ~/.dotfiles/config/mc/skins/Arasaka.ini ~/.local/share/mc/skins/Arasaka.ini 

# alacritty config
print_title "Alacritty configuration"
if [ "$os_name" == "macos" ]; then
	symlink ~/.dotfiles/config/alacritty/alacrittyMacos.yml ~/.config/alacritty/alacritty.yml
elif [ "$os_name" == "ubuntu" ]; then
	symlink ~/.dotfiles/config/alacritty/alacrittyLinux.yml ~/.config/alacritty/alacritty.yml
fi

# tmux config
print_title "tmux configuration"
symlink ~/.dotfiles/config/tmux/tmux.conf ~/.config/tmux/tmux.conf

# lunar vim config
print_title "LunarVim configuration"
symlink ~/.dotfiles/config/lvim/config.lua ~/.config/lvim/config.lua

# bat configuration
print_title "bat binary"
symlink /usr/bin/batcat ~/.local/bin/bat

# micro configuration
print_title "micro configuration"
symlink ~/.dotfiles/config/micro/excalith.micro ~/.config/micro/colorschemes/excalith.micro
