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
print_section "Installing Packages"


#==================================
# Add keys to apt
#==================================
print_title "Adding Keys"

apt_install "gpg" "gpg"
sudo mkdir -p /etc/apt/keyrings

# Eza
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg &> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list &> /dev/null
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list


# Charm
curl -fsSL --silent https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg &> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list &> /dev/null

#==================================
# Add repositories to apt
#==================================
print_title "Adding Repositories"
apt_add_repo "Universe" "universe"
apt_add_repo "Multiverse" "multiverse"
apt_add_repo "Fish" "ppa:fish-shell/release-3"


#==================================
# Update APT packages
#==================================
print_title "Update & Upgrade APT"
apt_update
apt_upgrade


#==================================
# Install APT packages
#==================================
print_title "Install APT Packages"


apt_install "curl" "curl"
apt_install "wget" "wget"
apt_install "unzip" "unzip"
apt_install "pyhton3" "python3"
apt_install "git" "git"
apt_install "git-all" "git-all"
apt_install "git-lfs" "git-lfs"
apt_install "cargo" "cargo"

apt_install "tmux" "tmux"
apt_install "less" "less"
apt_install "eza" "eza"
apt_install "bat" "bat"
apt_install "tree" "tree"
apt_install "tre-command" "tre-command"
apt_install "fasd" "fasd"
apt_install "fd-find" "fd-find"
apt_install "fzf" "fzf"
apt_install "zoxide" "zoxide"
apt_install "delta" "delta"
apt_install "ripgrep" "ripgrep"

apt_install "gum" "gum"
apt_install "htop" "htop"
apt_install "httpie" "httpie"
apt_install "prettyping" "prettyping"

apt_install "tldr" "tldr"
apt_install "neofetch" "neofetch"

apt_install "midnight-commander" "mc"
apt_install "node" "nodejs"
apt_install "yarn" "yarn"
apt_install "gcc" "gcc"
apt_install "micro" "micro"
apt_install "neovim" "neovim"
apt_install "ffmpeg" "ffmpeg"


#==================================
# Install Cargo packages
#==================================
# print_title "Install Cargo Packages"

# cargo_install "exa" "exa"


#==================================
# Install From Source
#==================================
print_title "Install Packages From Source"

# Tmux Plugin Manager (TPM)
execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"

# LazyGit: apt package on Ubuntu 25.10+, otherwise the latest release binary
if apt-cache show lazygit &>/dev/null; then
  apt_install "LazyGit" "lazygit"
else
  install_lazygit_release
fi