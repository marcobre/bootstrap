#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_alpine.sh"

#==================================
# Print Section Title
#==================================
print_section "Installing Packages"


#==================================
# Update APT packages
#==================================
print_title "Update Packages"
apk_update

#==================================
# Install apk packages
#==================================
print_title "Install apk Packages"

apk_install "git" "git"
apk_install "curl" "curl"
apk_install "wget" "wget"
apk_install "unzip" "unzip"
apk_install "pyhton3" "python3"
apk_install "jq" "jq"

apk_install "tmux" "tmux"
apk_install "less" "less"
apk_install "exa" "exa"
apk_install "bat" "bat"
apk_install "fasd" "fasd"
apk_install "fzf" "fzf"
apk_install "ripgrep" "ripgrep"

apk_install "htop" "htop"
apk_install "httpie" "httpie"
apk_install "prettyping" "prettyping"

apk_install "tldr" "tldr"
apk_install "neofetch" "neofetch"

apk_install "neovim" "neovim"


#==================================
# Install From Source
#==================================
print_title "Install Packages From Source"

# Tmux Plugin Manager (TPM)
rm -rf ~/.tmux/plugins/tpm
execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"


# LazyGit: latest release binary (static Go build, runs on musl)
install_lazygit_release

