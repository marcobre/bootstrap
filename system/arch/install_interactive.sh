#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_arch.sh"

#==================================
# Interactive Menu Functions
#==================================

show_welcome() {
    clear
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 60 --margin "1 2" --padding "1 2" \
        'Welcome to Marcom Dotfiles Setup' \
        'Interactive Arch Linux Installation'

    gum style \
        --foreground 241 --align center --width 60 --margin "0 2" \
        'This interactive installer will help you customize your Arch setup' \
        'Select only the components you need'
}

main_menu() {
    local choice
    choice=$(gum choose --cursor="→ " --height=12 --header="Select installation components:" \
        "Essential Setup (Symlinks + Defaults)" \
        "Package Management Setup" \
        "Development Tools" \
        "CLI Utilities" \
        "GUI Applications" \
        "AUR Packages" \
        "Fonts Installation" \
        "GNOME Extensions" \
        "Shell Configuration" \
        "Complete Installation (All Components)" \
        "Custom Selection" \
        "Exit")
    echo "$choice"
}

development_tools_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select development tools:" \
        "Git & Git Tools" \
        "Build Tools (base-devel, gcc)" \
        "Programming Languages (nodejs, yarn, python3)" \
        "Code Editors (neovim, micro)" \
        "Development Utilities (jq)" \
        "LazyGit (Git TUI)"
}

cli_utilities_menu() {
    gum choose --no-limit --cursor="→ " --height=15 --header="Select CLI utilities:" \
        "File Operations (eza, bat)" \
        "Search & Navigation (fzf, ripgrep, fasd)" \
        "System Monitoring (htop)" \
        "Network Tools (httpie, prettyping, mtr)" \
        "Terminal Enhancements (tmux, less, gum)" \
        "System Info (neofetch, tldr)" \
        "File Managers (ranger, mc)" \
        "Media Tools (ffmpeg)"
}

gui_applications_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select GUI applications:" \
        "GNOME Tools (gnome-tweaks, gnome-shell-extensions)" \
        "Terminal (Alacritty)" \
        "Security (gnupg)" \
        "Development Tools" \
        "Network Tools (curl, wget, ca-certificates)" \
        "Flatpak Applications"
}

flatpak_applications_menu() {
    gum choose --no-limit --cursor="→ " --height=15 --header="Select Flatpak applications:" \
        "Web Browsers (Firefox)" \
        "Development (Insomnia REST Client)" \
        "Communication (Telegram, Discord, Zoom)" \
        "Media (Spotify, VLC)" \
        "Utilities (Image Optimizer)" \
        "All Flatpak Apps"
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

gnome_extensions_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select GNOME extensions to install:" \
        "Dash To Dock (COSMIC)" \
        "User Themes" \
        "Blur My Shell" \
        "Rounded Corners" \
        "Places Status Indicator" \
        "Removable Drive Menu" \
        "Caffeine" \
        "All GNOME Extensions"
}

#==================================
# Installation Functions
#==================================

install_essential_setup() {
    print_section "Essential Setup"
    
    print_title "Creating Symlinks"
    . "$HOME/.dotfiles/system/symlink.sh"
    
    print_title "Setting Up Defaults"
    . "$HOME/.dotfiles/system/arch/setup_defaults.sh"
}

install_package_management() {
    print_section "Package Management Setup"
    
    print_title "Update System Packages"
    pacman_update

    print_title "Install Essential Packages"
    pacman_install "git" "git"
    pacman_install "base-devel" "base-devel"

    print_title "Install AUR Helper (yay)"
    if ! command -v yay &> /dev/null; then
        rm -rf ~/tmp/yay
        execute "git clone --quiet https://aur.archlinux.org/yay.git ~/tmp/yay" "Cloning yay"
        cd ~/tmp/yay
        execute "makepkg -sfci --noconfirm --needed" "Building yay"
        cd ~
    fi

    print_title "Install Package Managers"
    pacman_install "flatpak" "flatpak"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1
}

install_development_tools() {
    local selected_tools="$1"
    print_section "Installing Development Tools"
    
    if echo "$selected_tools" | grep -q "Git & Git Tools"; then
        pacman_install "git" "git"
        pacman_install "git-lfs" "git-lfs"
    fi
    
    if echo "$selected_tools" | grep -q "Build Tools"; then
        pacman_install "base-devel" "base-devel"
        pacman_install "gcc" "gcc"
    fi
    
    if echo "$selected_tools" | grep -q "Programming Languages"; then
        pacman_install "nodejs" "nodejs"
        pacman_install "yarn" "yarn"
        pacman_install "python3" "python3"
    fi
    
    if echo "$selected_tools" | grep -q "Code Editors"; then
        pacman_install "neovim" "neovim"
        pacman_install "micro" "micro"
    fi
    
    if echo "$selected_tools" | grep -q "Development Utilities"; then
        pacman_install "jq" "jq"
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
    
    echo "$selected_utils" | grep -q "File Operations" && {
        pacman_install "eza" "eza"
        pacman_install "bat" "bat"
    }
    
    echo "$selected_utils" | grep -q "Search" && {
        pacman_install "fzf" "fzf"
        pacman_install "ripgrep" "ripgrep"
        pacman_install "fasd" "fasd"
    }
    
    echo "$selected_utils" | grep -q "System Monitoring" && pacman_install "htop" "htop"
    
    echo "$selected_utils" | grep -q "Network Tools" && {
        pacman_install "httpie" "httpie"
        pacman_install "prettyping" "prettyping"
        pacman_install "mtr" "mtr"
    }
    
    echo "$selected_utils" | grep -q "Terminal Enhancements" && {
        pacman_install "tmux" "tmux"
        pacman_install "less" "less"
        pacman_install "gum" "gum"
    }
    
    echo "$selected_utils" | grep -q "System Info" && {
        pacman_install "neofetch" "neofetch"
        pacman_install "tldr" "tldr"
    }
    
    echo "$selected_utils" | grep -q "File Managers" && {
        pacman_install "ranger" "ranger"
        pacman_install "mc" "mc"
    }
    
    echo "$selected_utils" | grep -q "Media Tools" && pacman_install "ffmpeg" "ffmpeg"
}

install_gui_applications() {
    local selected_apps="$1"
    print_section "Installing GUI Applications"
    
    if echo "$selected_apps" | grep -q "GNOME Tools"; then
        pacman_install "gnome-tweaks" "gnome-tweaks"
        pacman_install "gnome-shell-extensions" "gnome-shell-extensions"
    fi
    
    echo "$selected_apps" | grep -q "Terminal" && pacman_install "alacritty" "alacritty"
    echo "$selected_apps" | grep -q "Security" && pacman_install "gnupg" "gnupg"
    
    if echo "$selected_apps" | grep -q "Network Tools"; then
        pacman_install "curl" "curl"
        pacman_install "wget" "wget"
        pacman_install "ca-certificates" "ca-certificates"
    fi
    
    if echo "$selected_apps" | grep -q "Flatpak"; then
        install_flatpak_applications "All Flatpak Apps"
    fi
}

install_flatpak_applications() {
    local selected_apps="$1"
    print_section "Installing Flatpak Applications"
    
    if echo "$selected_apps" | grep -q "All Flatpak Apps"; then
        flatpak_install "Firefox" "org.mozilla.firefox"
        flatpak_install "Insomnia" "rest.insomnia.Insomnia"
        flatpak_install "Image Optimizer" "com.github.gijsgoudzwaard.image-optimizer"
        flatpak_install "Telegram" "org.telegram.desktop"
        flatpak_install "Discord" "com.discordapp.Discord"
        flatpak_install "Zoom" "us.zoom.Zoom"
        flatpak_install "Spotify" "com.spotify.Client"
        flatpak_install "VLC" "org.videolan.VLC"
    else
        echo "$selected_apps" | grep -q "Web Browsers" && flatpak_install "Firefox" "org.mozilla.firefox"
        echo "$selected_apps" | grep -q "Development" && flatpak_install "Insomnia" "rest.insomnia.Insomnia"
        echo "$selected_apps" | grep -q "Communication" && {
            flatpak_install "Telegram" "org.telegram.desktop"
            flatpak_install "Discord" "com.discordapp.Discord"
            flatpak_install "Zoom" "us.zoom.Zoom"
        }
        echo "$selected_apps" | grep -q "Media" && {
            flatpak_install "Spotify" "com.spotify.Client"
            flatpak_install "VLC" "org.videolan.VLC"
        }
        echo "$selected_apps" | grep -q "Utilities" && flatpak_install "Image Optimizer" "com.github.gijsgoudzwaard.image-optimizer"
    fi
}

install_selected_fonts() {
    local selected_fonts="$1"
    print_section "Installing Selected Fonts"
    
    # Use the existing Arch font installation script
    if [[ -f "$HOME/.dotfiles/system/arch/setup_fonts.sh" ]]; then
        if echo "$selected_fonts" | grep -q "All Fonts"; then
            # Install all fonts
            . "$HOME/.dotfiles/system/arch/setup_fonts.sh"
        else
            # Install only selected fonts
            # For now, we'll use the existing script and modify it later for selection
            . "$HOME/.dotfiles/system/arch/setup_fonts.sh"
        fi
    else
        print_warning "Font installation script not found. Skipping font installation."
    fi
}

install_gnome_extensions() {
    local selected_extensions="$1"
    print_section "Installing GNOME Extensions"
    
    if echo "$selected_extensions" | grep -q "All GNOME Extensions"; then
        extension_install "Dash To Dock (COSMIC)" "https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/"
        extension_install "User Themes" "https://extensions.gnome.org/extension/19/user-themes/"
        extension_install "Blur My Shell" "https://extensions.gnome.org/extension/3193/blur-my-shell/"
        extension_install "Rounded Corners" "https://extensions.gnome.org/extension/1514/rounded-corners/"
        extension_install "Places Status Indicator" "https://extensions.gnome.org/extension/8/places-status-indicator/"
        extension_install "Removable Drive Menu" "https://extensions.gnome.org/extension/7/removable-drive-menu/"
        extension_install "Caffeine" "https://extensions.gnome.org/extension/517/caffeine/"
    else
        echo "$selected_extensions" | grep -q "Dash To Dock" && extension_install "Dash To Dock (COSMIC)" "https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/"
        echo "$selected_extensions" | grep -q "User Themes" && extension_install "User Themes" "https://extensions.gnome.org/extension/19/user-themes/"
        echo "$selected_extensions" | grep -q "Blur My Shell" && extension_install "Blur My Shell" "https://extensions.gnome.org/extension/3193/blur-my-shell/"
        echo "$selected_extensions" | grep -q "Rounded Corners" && extension_install "Rounded Corners" "https://extensions.gnome.org/extension/1514/rounded-corners/"
        echo "$selected_extensions" | grep -q "Places Status" && extension_install "Places Status Indicator" "https://extensions.gnome.org/extension/8/places-status-indicator/"
        echo "$selected_extensions" | grep -q "Removable Drive" && extension_install "Removable Drive Menu" "https://extensions.gnome.org/extension/7/removable-drive-menu/"
        echo "$selected_extensions" | grep -q "Caffeine" && extension_install "Caffeine" "https://extensions.gnome.org/extension/517/caffeine/"
    fi
}

install_shell_config() {
    print_section "Shell Configuration"
    . "$HOME/.dotfiles/system/arch/setup_shell.sh"
}

install_source_packages() {
    print_section "Installing Source Packages"
    
    print_title "TMUX Plugin Manager (TPM)"
    rm -rf ~/.tmux/plugins/tpm
    execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"
    
    print_title "Reversal Icons"
    wget -qO ~/reversal.tar.gz https://github.com/yeyushengfan258/Reversal-icon-theme/archive/master.tar.gz
    mkdir -p ~/reversal-icons
    tar --extract \
        --gzip \
        --file ~/reversal.tar.gz \
        --strip-components 1 \
        --directory ~/reversal-icons

    cd ~/reversal-icons && . install.sh -a &>/dev/null
    print_success "Reversal Icons"

    rm -rf ~/reversal-icons ~/reversal.tar.gz
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
            "AUR Packages")
                selected_apps=$(flatpak_applications_menu)
                if [[ -n "$selected_apps" ]]; then
                    install_flatpak_applications "$selected_apps"
                    gum style --foreground 212 "✨ Flatpak applications installation completed!"
                fi
                ;;
            "Fonts Installation")
                selected_fonts=$(fonts_menu)
                if [[ -n "$selected_fonts" ]]; then
                    install_selected_fonts "$selected_fonts"
                    gum style --foreground 212 "✨ Fonts installation completed!"
                fi
                ;;
            "GNOME Extensions")
                selected_extensions=$(gnome_extensions_menu)
                if [[ -n "$selected_extensions" ]]; then
                    install_gnome_extensions "$selected_extensions"
                    gum style --foreground 212 "✨ GNOME extensions installation completed!"
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
                    install_development_tools "Git & Git Tools Build Tools Programming Languages Code Editors Development Utilities LazyGit"
                    install_cli_utilities "File Operations Search & Navigation System Monitoring Network Tools Terminal Enhancements System Info File Managers Media Tools"
                    install_gui_applications "GNOME Tools Terminal Security Network Tools Flatpak Applications"
                    install_selected_fonts "All Fonts"
                    install_gnome_extensions "All GNOME Extensions"
                    install_shell_config
                    install_source_packages
                    gum style --foreground 212 "✨ Complete installation finished!"
                }
                ;;
            "Custom Selection")
                gum style --foreground 214 "Custom installation mode:"
                gum style --foreground 241 "Select individual components from the main menu"
                ;;
            "Exit")
                gum style --foreground 212 "👋 Installation cancelled. Goodbye!"
                exit 0
                ;;
        esac
        
        echo
        gum confirm "Return to main menu?" || break
        clear
        show_welcome
    done
    
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 50 --margin "1 2" --padding "1 2" \
        '🎉 Installation Complete!' \
        'Your Arch Linux system is now configured.'
}

#==================================
# Start Interactive Installation
#==================================
print_section "Interactive Arch Dotfiles Setup"

# Check if gum is available, install if needed
if ! command -v gum &> /dev/null; then
    print_title "Installing gum for interactive menus"
    pacman_install "gum" "gum"
fi

main_interactive
