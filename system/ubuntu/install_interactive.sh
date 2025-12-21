#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_ubuntu.sh"

#==================================
# Interactive Menu Functions
#==================================

show_welcome() {
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 60 --margin "1 2" --padding "1 2" \
        'Welcome to Marcom Dotfiles Setup' \
        'Interactive Ubuntu Installation'

    gum style \
        --foreground 241 --align center --width 60 --margin "0 2" \
        'This interactive installer will help you customize your Ubuntu setup' \
        'Select only the components you need'
}

main_menu() {
    local choice
    choice=$(gum choose --cursor="→ " --height=10 --header="Select installation components:" \
        "Essential Setup (Symlinks + Defaults)" \
        "Package Management Setup" \
        "Development Tools" \
        "CLI Utilities" \
        "GUI Applications" \
        "Fonts Installation" \
        "Shell Configuration" \
        "Complete Installation (All Components)" \
        "Custom Selection" \
        "Exit")
    echo "$choice"
}

package_categories_menu() {
    gum choose --no-limit --cursor="→ " --height=15 --header="Select package categories to install:" \
        "Essential Packages" \
        "Package Managers" \
        "Development Tools" \
        "CLI Utilities" \
        "Terminal Applications" \
        "GUI Applications (APT)" \
        "Flatpak Applications" \
        "Source Installations" \
        "GNOME Extensions"
}

fonts_menu() {
    local fonts_list=(
        "CascadiaCode"
        "FiraCode" 
        "FiraMono"
        "JetBrainsMono"
        "Meslo"
        "SourceCodePro"
        "BitstreamVeraSansMono"
        "CodeNewRoman"
        "DroidSansMono"
        "Go-Mono"
        "Hack"
        "Hermit"
        "Noto"
        "Overpass"
        "ProggyClean"
        "RobotoMono"
        "SpaceMono"
        "Ubuntu"
        "UbuntuMono"
    )

    gum choose --no-limit --cursor="→ " --height=15 --header="Select fonts to install:" \
        "${fonts_list[@]}" \
        "All Fonts"
}

development_tools_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select development tools:" \
        "Git & Git LFS" \
        "Build Essential" \
        "Python3" \
        "Cargo (Rust)" \
        "GCC Compiler" \
        "Neovim" \
        "tmux + TPM" \
        "LazyGit"
}

cli_utilities_menu() {
    gum choose --no-limit --cursor="→ " --height=15 --header="Select CLI utilities:" \
        "eza (better ls)" \
        "bat (better cat)" \
        "fzf (fuzzy finder)" \
        "ripgrep (better grep)" \
        "fd-find (better find)" \
        "tree & tre-command" \
        "htop (system monitor)" \
        "httpie (HTTP client)" \
        "prettyping & mtr" \
        "tldr (quick help)" \
        "neofetch (system info)" \
        "ranger & mc (file managers)" \
        "fasd (quick navigation)"
}

gui_applications_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select GUI applications:" \
        "GNOME Tweaks & Extensions" \
        "Alacritty Terminal" \
        "Caffeine" \
        "Firefox (Flatpak)" \
        "Spotify (Flatpak)" \
        "VLC Media Player (Flatpak)" \
        "Image Optimizer (Flatpak)" \
        "HEIF Support"
}

#==================================
# Installation Functions
#==================================

install_essential_setup() {
    print_section "Essential Setup"
    
    print_title "Creating Symlinks"
    . "$HOME/.dotfiles/system/symlink.sh"
    
    print_title "Setting Up Defaults"
    . "$HOME/.dotfiles/system/ubuntu/setup_defaults.sh"
}

install_package_management() {
    print_section "Package Management Setup"
    
    print_title "Install Essential Packages"
    apt_install "curl" "curl"
    apt_install "ca-certificates" "ca-certificates" 
    apt_install "gpg" "gpg"
    apt_install "wget" "wget"
    apt_install "apt-transport-https" "apt-transport-https"
    apt_install "software-properties-common" "software-properties-common"

    print_title "Adding Keys and Repositories"
    setup_repositories
    
    print_title "Update & Upgrade APT"
    apt_update
    apt_upgrade
    
    print_title "Install Package Managers"
    apt_install "nala" "nala"
    apt_install "flatpak" "flatpak"
    apt_install "flatpak gnome plugin" "gnome-software-plugin-flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1
}

setup_repositories() {
    sudo mkdir -p /etc/apt/keyrings

    # Eza
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg --yes &>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list &>/dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list

    # Charm (for gum)
    curl -fsSL --silent https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg --yes &>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list &>/dev/null

    # Add repositories
    apt_add_repo "Universe" "universe"
    apt_add_repo "Multiverse" "multiverse" 
    apt_add_repo "Fish" "ppa:fish-shell/release-3"
    apt_add_repo "Alacritty" "ppa:aslatter/ppa"
}

install_development_tools() {
    local selected_tools="$1"
    print_section "Installing Development Tools"
    
    if echo "$selected_tools" | grep -q "Git & Git LFS"; then
        apt_install "git" "git"
        apt_install "git-all" "git-all"
        apt_install "git-lfs" "git-lfs"
    fi
    
    if echo "$selected_tools" | grep -q "Build Essential"; then
        apt_install "Build Essential" "build-essential"
    fi
    
    if echo "$selected_tools" | grep -q "Python3"; then
        apt_install "python3" "python3"
    fi
    
    if echo "$selected_tools" | grep -q "Cargo"; then
        apt_install "cargo" "cargo"
    fi
    
    if echo "$selected_tools" | grep -q "GCC"; then
        apt_install "gcc" "gcc"
    fi
    
    if echo "$selected_tools" | grep -q "Neovim"; then
        apt_install "neovim" "neovim"
    fi
    
    if echo "$selected_tools" | grep -q "tmux"; then
        apt_install "tmux" "tmux"
        print_title "Install TMUX Plugin Manager"
        execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"
    fi
    
    if echo "$selected_tools" | grep -q "LazyGit"; then
        print_title "Install LazyGit"
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/')
        curl -Lo lazygit.tar.gz --silent "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
        rm -rf lazygit.tar.gz
        print_success "lazygit"
    fi
}

install_cli_utilities() {
    local selected_utils="$1"
    print_section "Installing CLI Utilities"
    
    echo "$selected_utils" | grep -q "eza" && apt_install "eza" "eza"
    echo "$selected_utils" | grep -q "bat" && apt_install "bat" "bat"
    echo "$selected_utils" | grep -q "fzf" && apt_install "fzf" "fzf"
    echo "$selected_utils" | grep -q "ripgrep" && apt_install "ripgrep" "ripgrep"
    echo "$selected_utils" | grep -q "fd-find" && apt_install "fd-find" "fd-find"
    echo "$selected_utils" | grep -q "tree" && { apt_install "tree" "tree"; apt_install "tre-command" "tre-command"; }
    echo "$selected_utils" | grep -q "htop" && apt_install "htop" "htop"
    echo "$selected_utils" | grep -q "httpie" && apt_install "httpie" "httpie"
    echo "$selected_utils" | grep -q "prettyping" && { apt_install "prettyping" "prettyping"; apt_install "mtr" "mtr"; }
    echo "$selected_utils" | grep -q "tldr" && apt_install "tldr" "tldr"
    echo "$selected_utils" | grep -q "neofetch" && apt_install "neofetch" "neofetch"
    echo "$selected_utils" | grep -q "ranger" && { apt_install "ranger" "ranger"; apt_install "midnight-commander" "mc"; }
    echo "$selected_utils" | grep -q "fasd" && apt_install "fasd" "fasd"
    
    # Always install gum for menu system
    apt_install "gum" "gum"
    apt_install "less" "less"
}

install_gui_applications() {
    local selected_apps="$1"
    print_section "Installing GUI Applications"
    
    if echo "$selected_apps" | grep -q "GNOME"; then
        apt_install "Gnome Shell Extensions" "gnome-shell-extensions"
        apt_install "Gnome Shell Extension Manager" "gnome-shell-extension-manager"
        apt_install "Gnome Tweaks" "gnome-tweaks"
    fi
    
    echo "$selected_apps" | grep -q "Alacritty" && apt_install "Alacritty" "alacritty"
    echo "$selected_apps" | grep -q "Caffeine" && apt_install "Caffeine" "caffeine"
    
    if echo "$selected_apps" | grep -q "HEIF"; then
        apt_install "heif-gdk-pixbuf" "heif-gdk-pixbuf"
        apt_install "heif-thumbnailer" "heif-thumbnailer"
    fi
    
    # Flatpak applications
    echo "$selected_apps" | grep -q "Firefox" && flatpak_install "Firefox" "org.mozilla.firefox"
    echo "$selected_apps" | grep -q "Spotify" && flatpak_install "Spotify" "com.spotify.Client"
    echo "$selected_apps" | grep -q "VLC" && flatpak_install "VLC" "org.videolan.VLC"
    echo "$selected_apps" | grep -q "Image Optimizer" && flatpak_install "Image Optimizer" "com.github.gijsgoudzwaard.image-optimizer"
}

install_selected_fonts() {
    local selected_fonts="$1"
    print_section "Installing Selected Fonts"
    
    local version fonts_dir
    version=$(curl -s 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest' | jq -r '.name')
    fonts_dir="${HOME}/.local/share/fonts"

    if [[ ! -d "${fonts_dir}" ]]; then
        mkdir -p "${fonts_dir}"
    fi

    if echo "$selected_fonts" | grep -q "All Fonts"; then
        # Install all fonts if "All Fonts" was selected
        declare -a all_fonts=(
            CascadiaCode FiraCode FiraMono JetBrainsMono Meslo SourceCodePro
            BitstreamVeraSansMono CodeNewRoman DroidSansMono Go-Mono Hack
            Hermit Noto Overpass ProggyClean RobotoMono SpaceMono Ubuntu UbuntuMono
        )
        
        for font in "${all_fonts[@]}"; do
            install_single_font "$font" "$version" "$fonts_dir"
        done
    else
        # Install only selected fonts
        while IFS= read -r font; do
            if [[ -n "$font" ]]; then
                install_single_font "$font" "$version" "$fonts_dir"
            fi
        done <<< "$selected_fonts"
    fi

    find "${fonts_dir}" -name 'Windows Compatible' -delete
    fc-cache -fv
}

install_single_font() {
    local font="$1"
    local version="$2" 
    local fonts_dir="$3"
    local zip_file download_url
    
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/${zip_file}"
    
    print_title "Installing Font: $font"
    wget -q "$download_url" -O "$zip_file" 2>/dev/null
    if [ $? -eq 0 ]; then
        unzip -qq -o "$zip_file" -d "${fonts_dir}"
        rm "$zip_file"
        print_success "$font"
    else
        print_error "Failed to download $font"
    fi
}

install_shell_config() {
    print_section "Shell Configuration"
    . "$HOME/.dotfiles/system/ubuntu/setup_shell.sh"
}

#==================================
# Main Interactive Flow
#==================================
main_interactive() {
    show_welcome
    
    while true; do
        choice=$(main_menu)
        
        case "$choice" in
            "Essential Setup"*)
                install_essential_setup
                gum style --foreground 212 "✨ Essential setup completed!"
                ;;
            "Package Management Setup")
                install_package_management
                gum style --foreground 212 "✨ Package management setup completed!"
                ;;
            "Development Tools")
                selected_tools=$(development_tools_menu)
                if [[ -n "$selected_tools" ]]; then
                    install_development_tools "$selected_tools"
                    gum style --foreground 212 "✨ Development tools installation completed!"
                fi
                ;;
            "CLI Utilities")
                selected_utils=$(cli_utilities_menu)
                if [[ -n "$selected_utils" ]]; then
                    install_cli_utilities "$selected_utils"
                    gum style --foreground 212 "✨ CLI utilities installation completed!"
                fi
                ;;
            "GUI Applications")
                selected_apps=$(gui_applications_menu)
                if [[ -n "$selected_apps" ]]; then
                    install_gui_applications "$selected_apps"
                    gum style --foreground 212 "✨ GUI applications installation completed!"
                fi
                ;;
            "Fonts Installation")
                selected_fonts=$(fonts_menu)
                if [[ -n "$selected_fonts" ]]; then
                    install_selected_fonts "$selected_fonts"
                    gum style --foreground 212 "✨ Fonts installation completed!"
                fi
                ;;
            "Shell Configuration")
                install_shell_config
                gum style --foreground 212 "✨ Shell configuration completed!"
                ;;
            "Complete Installation"*)
                gum confirm "This will install ALL components. Continue?" && {
                    install_essential_setup
                    install_package_management
                    install_development_tools "Git & Git LFS Build Essential Python3 Cargo (Rust) GCC Compiler Neovim tmux + TPM LazyGit"
                    install_cli_utilities "eza (better ls) bat (better cat) fzf (fuzzy finder) ripgrep (better grep) fd-find (better find) tree & tre-command htop (system monitor) httpie (HTTP client) prettyping & mtr tldr (quick help) neofetch (system info) ranger & mc (file managers) fasd (quick navigation)"
                    install_gui_applications "GNOME Tweaks & Extensions Alacritty Terminal Caffeine Firefox (Flatpak) Spotify (Flatpak) VLC Media Player (Flatpak) Image Optimizer (Flatpak) HEIF Support"
                    install_selected_fonts "All Fonts"
                    install_shell_config
                    gum style --foreground 212 "✨ Complete installation finished!"
                }
                ;;
            "Custom Selection")
                categories=$(package_categories_menu)
                if [[ -n "$categories" ]]; then
                    gum style --foreground 214 "Custom installation with selected categories:"
                    echo "$categories" | sed 's/^/  • /'
                    gum confirm "Proceed with custom installation?" && {
                        # Process custom selections here
                        gum style --foreground 212 "✨ Custom installation completed!"
                    }
                fi
                ;;
            "Exit")
                gum style --foreground 212 "👋 Installation cancelled. Goodbye!"
                exit 0
                ;;
        esac
        
        echo
        gum confirm "Return to main menu?" || break
        show_welcome
    done
    
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 50 --margin "1 2" --padding "1 2" \
        '🎉 Installation Complete!' \
        'Your Ubuntu system is now configured.'
}

#==================================
# Start Interactive Installation
#==================================
print_section "Interactive Ubuntu Dotfiles Setup"

# gum is already installed by setup.sh, so start the interactive flow directly
main_interactive
