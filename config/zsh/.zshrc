# If you come from bash you might have to change your $PATH.
export LANG=de_DE.UTF-8
export LANGUAGE=de_DE.UTF-8
export LC_ALL=de_DE.UTF-8

# Dotfiles Path
export DOTFILES_PATH="$HOME/.dotfiles"	

# export PATH
export PATH=$HOME/.local/bin:$HOME/local/sbin:$HOME/bin:$PATH:~/.cargo/bin:~/.config/emacs/bin

# forgit
export PATH="$PATH:$FORGIT_INSTALL_DIR/bin"

# Disable Gatekeeper for homebrew
export HOMEBREW_CASK_OPTS="--no-quarantine --no-binaries"

# Export GPG TTY
export GPG_TTY=$(tty)

# Set default terminal
#export TERM=alacritty

# Micro True Color
export "MICRO_TRUECOLOR=1"

# Set default editor
export EDITOR="nvim"

# Enable mouse scroll for less
export LESS=-R
export LESS='--mouse --wheel-lines=3'
export COLUMNS=80

# Setup Bat
export BAT_PAGER="less -RF"

# Setup FASD
#eval "$(fasd --init auto)"

# Setup Antigen
source "$HOME/.config/antigen.zsh"

# Setup Plugins
#antigen bundle wfxr/forgit
antigen bundle unixorn/fzf-zsh-plugin@main
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle leophys/zsh-plugin-fzf-finder
antigen apply

# ZSH Highlight Configuration
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

# Setup FZF
[ -f ~/.fzf/.fzf.zsh ] && source ~/.fzf/.fzf.zsh

# export FZF_TMUX=1
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_OPTS='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap"

# Easy navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Include ZSH Local
source "$HOME/.zsh.local"
source "$HOME/.config/bash/aliases.bash"
source "$HOME/.config/bash/functions.bash"
source "$HOME/.config/aliases"

# Source starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# Reload zsh sessions
function sreload() {
    source "$HOME/.zshrc"
	source "$HOME/.zsh.local"
	source "$HOME/.config/bash/aliases.bash"
	source "$HOME/.config/bash/functions.bash"

    tmux display-message "ZSH Shell Config Reloaded"
}

# Update shell
function supdate() {
    printf "\nUpdating zsh\n"
    OS=$(uname)
    case $OS in
    Linux)
        sudo apt upgrade -qqy --fix-missing && sudo apt install --allow-unauthenticated -qqy "zsh"
        ;;
    Darwin)
        brew upgrade zsh
        ;;
    esac

    tmux display-message "ZSH Shell Update Complete"
}

export PATH=$HOME/.toolbox/bin:$PATH
#source ~/.$(basename "$SHELL")rc
eval "$(/opt/homebrew/bin/brew shellenv)"

# Source MLU config
source ~/.config/mlu/burner_config

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
