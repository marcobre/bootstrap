# Fish User Paths
set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# Dotfiles Path
set -gx DOTFILES_PATH "$HOME/.dotfiles"	

# Language Default
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

# Set default terminal
#set -gx TERM alacritty

set -gx PATH "/usr/local/sbin:~/.local/bin:$PATH:~/.cargo/bin"

# Add Path
fish_add_path "./bin"
fish_add_path "/usr/local/bin"
fish_add_path "/usr/local/sbin"
fish_add_path "/usr/local/opt/"

# Export Homebrew Path
set -gx HOMEBREW_CURL_PATH "/usr/bin/curl"

# Micro True Color
set -gx MICRO_TRUECOLOR 1

# Export GPG TTY
set -gx GPG_TTY $(tty)

# Enable mouse scroll for less
set -gx LESS -R
set -gx LESS '--mouse --wheel-lines=3'
set -gx COLUMNS 80

# Setup Bat
set -gx BAT_PAGER "less -RF"

# Editor
set -gx EDITOR "lvim"

# FZF
set -gx FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
set -gx FZF_CTRL_T_OPTS '--preview "bat --style=numbers --color=always --line-range :500 {}"'
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap"

# Grep colors
setenv GREP_OPTIONS "--color=auto"

# after `forgit` was loaded
export PATH="$PATH:$FORGIT_INSTALL_DIR/bin"
