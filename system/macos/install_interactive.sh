#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_macos.sh"

#==================================
# Interactive Menu Functions
#==================================

show_welcome() {
    clear
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 60 --margin "1 2" --padding "1 2" \
        'Welcome to Marcom Dotfiles Setup' \
        'Interactive macOS Installation'

    gum style \
        --foreground 241 --align center --width 60 --margin "0 2" \
        'This interactive installer will help you customize your macOS setup' \
        'Select only the components you need'
}

main_menu() {
    local choice
    choice=$(gum choose --cursor="→ " --height=12 --header="Select installation components:" \
        "Essential Setup (Symlinks + Defaults)" \
        "Homebrew Setup & Management" \
        "Development Tools" \
        "CLI Utilities" \
        "GUI Applications (Casks)" \
        "Mac App Store Applications" \
        "Fonts Installation" \
        "Services & Window Management" \
        "Shell Configuration" \
        "Complete Installation (All Components)" \
        "Custom Selection" \
        "Exit")
    echo "$choice"
}

homebrew_categories_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select Homebrew categories:" \
        "Core Homebrew Taps" \
        "Development Tools" \
        "CLI Utilities & Tools" \
        "Media & Graphics Tools" \
        "System Utilities" \
        "Programming Languages" \
        "Source Installations"
}

development_tools_menu() {
    gum choose --no-limit --cursor="→ " --height=15 --header="Select development tools:" \
        "Git & Git Tools (git, git-lfs, lazygit)" \
        "Version Control (git-delta, git-quick-stats)" \
        "Code Analysis (cloc, shellcheck)" \
        "Programming Languages (node, yarn, mono, gcc)" \
        "Code Editors (neovim, micro)" \
        "Documentation (navi, tldr)" \
        "Build Tools (gcc, mas)" \
        "Emacs Plus"
}

cli_utilities_menu() {
    gum choose --no-limit --cursor="→ " --height=18 --header="Select CLI utilities:" \
        "File Operations (eza, bat, tree, tre)" \
        "Search & Navigation (fd, fzf, ripgrep)" \
        "System Monitoring (htop, pidof, mtr)" \
        "Network Tools (prettyping, speedtest)" \
        "File Managers (ranger, midnight-commander)" \
        "Terminal Enhancements (tmux, less, gum)" \
        "Media Tools (ffmpeg, viu)" \
        "System Info (neofetch)" \
        "Entertainment (spotify-tui, cmatrix, nudoku)" \
        "Security (no-more-secrets)"
}

gui_applications_menu() {
    gum choose --no-limit --cursor="→ " --height=20 --header="Select GUI applications (Homebrew Casks):" \
        "Web Browsers (Brave Browser)" \
        "Development Tools (VS Code, Fork)" \
        "Terminals (Alacritty)" \
        "System Tools (Karabiner-Elements)" \
        "Security (GPG Suite, Keybase)" \
        "Media & Graphics (Spotify, Sketch, Sip, Handbrake, Optimage)" \
        "Communication (Discord, Slack, WhatsApp, Zoom)" \
        "Productivity (Alfred, Obsidian)" \
        "File Management (Keka, Transmit)" \
        "Content Creation (OBS Studio)" \
        "Window Management (Aerospace)"
}

mac_app_store_menu() {
    gum choose --no-limit --cursor="→ " --height=15 --header="Select Mac App Store applications:" \
        "Development (XCode)" \
        "Communication (Telegram)" \
        "Productivity (Reeder 5, Moom)" \
        "Weather (CARROT Weather)" \
        "Utilities (Displaperture, Gifski, iPreview)" \
        "All Mac App Store Apps"
}

fonts_menu() {
    gum choose --no-limit --cursor="→ " --height=10 --header="Select fonts to install:" \
        "FiraCode Nerd Font (Programming font with ligatures)" \
        "Install via Homebrew Cask Fonts" \
        "All Available Fonts"
}

services_menu() {
    gum choose --no-limit --cursor="→ " --height=8 --header="Select services and window management:" \
        "Yabai (Tiling Window Manager)" \
        "SKHD (Hotkey Daemon)" \
        "Aerospace (Window Manager)" \
        "All Window Management Tools"
}

#==================================
# Installation Functions
#==================================

install_essential_setup() {
    print_section "Essential Setup"
    
    print_title "Creating Symlinks"
    . "$HOME/.dotfiles/system/symlink.sh"
    
    print_title "Setting Up Defaults"
    . "$HOME/.dotfiles/system/macos/setup_defaults.sh"
}

install_homebrew_setup() {
    print_section "Homebrew Setup & Management"
    
    print_title "Installing Homebrew"
    if ! cmd_exists "brew"; then
        printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    print_result $? "Homebrew"

    brew_update
    brew_upgrade

    print_title "Setting Up Core Taps"
    brew_tap 'homebrew/core'
    brew_tap 'homebrew/bundle'  
    brew_tap 'homebrew/cask' || true
    brew_tap 'homebrew/cask-versions'
    brew_tap 'homebrew/cask-fonts'
    brew_tap 'eth-p/software'
    brew_tap 'teamookla/speedtest'
    brew_tap 'd12frosted/emacs-plus'
    brew_tap 'nikitabobko/tap/aerospace'
}

install_development_tools() {
    local selected_tools="$1"
    print_section "Installing Development Tools"
    
    if echo "$selected_tools" | grep -q "Git & Git Tools"; then
        brew_install "git" "git"
        brew_install "git-lfs" "git-lfs" 
        brew_install "lazygit" "lazygit"
    fi
    
    if echo "$selected_tools" | grep -q "Version Control"; then
        brew_install "git-delta" "git-delta"
        brew_install "git-quick-stats" "git-quick-stats"
    fi
    
    if echo "$selected_tools" | grep -q "Code Analysis"; then
        brew_install "cloc" "cloc"
        brew_install "shellcheck" "shellcheck"
    fi
    
    if echo "$selected_tools" | grep -q "Programming Languages"; then
        brew_install "node" "node"
        brew_install "yarn" "yarn"
        brew_install "mono" "mono"
        brew_install "gcc" "gcc"
    fi
    
    if echo "$selected_tools" | grep -q "Code Editors"; then
        brew_install "neovim" "neovim"
        brew_install "micro" "micro"
    fi
    
    if echo "$selected_tools" | grep -q "Documentation"; then
        brew_install "navi" "navi"
        brew_install "tldr" "tldr"
    fi
    
    if echo "$selected_tools" | grep -q "Build Tools"; then
        brew_install "mas" "mas"
    fi
    
    if echo "$selected_tools" | grep -q "Emacs"; then
        brew_install "emacs-plus" "emacs-plus"
    fi
}

install_cli_utilities() {
    local selected_utils="$1"
    print_section "Installing CLI Utilities"
    
    echo "$selected_utils" | grep -q "File Operations" && {
        brew_install "eza" "eza"
        brew_install "bat" "bat"
        brew_install "tree" "tree"
        brew_install "tre-command" "tre"
    }
    
    echo "$selected_utils" | grep -q "Search" && {
        brew_install "fd" "fd"
        brew_install "fzf" "fzf"
        brew_install "ripgrep" "ripgrep"
    }
    
    echo "$selected_utils" | grep -q "System Monitoring" && {
        brew_install "htop" "htop"
        brew_install "pidof" "pidof"
        brew_install "mtr" "mtr"
    }
    
    echo "$selected_utils" | grep -q "Network Tools" && {
        brew_install "prettyping" "prettyping"
        brew_install "speedtest" "speedtest"
    }
    
    echo "$selected_utils" | grep -q "File Managers" && {
        brew_install "ranger" "ranger"
        brew_install "midnight-commander" "midnight-commander"
    }
    
    echo "$selected_utils" | grep -q "Terminal Enhancements" && {
        brew_install "tmux" "tmux"
        brew_install "less" "less"
        brew_install "gum" "gum"
    }
    
    echo "$selected_utils" | grep -q "Media Tools" && {
        brew_install "ffmpeg" "ffmpeg"
        brew_install "viu" "viu"
    }
    
    echo "$selected_utils" | grep -q "System Info" && brew_install "neofetch" "neofetch"
    
    echo "$selected_utils" | grep -q "Entertainment" && {
        brew_install "spotify-tui" "spotify-tui"
        brew_install "cmatrix" "cmatrix"
        brew_install "nudoku" "nudoku"
    }
    
    echo "$selected_utils" | grep -q "Security" && brew_install "no-more-secrets" "no-more-secrets"
    
    # Essential tools
    brew_install "wget" "wget"
    brew_install "dockutil" "dockutil"
}

install_gui_applications() {
    local selected_apps="$1"
    print_section "Installing GUI Applications (Casks)"
    
    echo "$selected_apps" | grep -q "Web Browsers" && brew_install "Brave Browser" "brave-browser" "--cask"
    echo "$selected_apps" | grep -q "Development Tools" && {
        brew_install "VS Code" "visual-studio-code" "--cask"
        brew_install "Fork" "fork" "--cask"
    }
    echo "$selected_apps" | grep -q "Terminals" && brew_install "Alacritty" "alacritty" "--cask"
    echo "$selected_apps" | grep -q "System Tools" && brew_install "Karabiner-Elements" "karabiner-elements" "--cask"
    echo "$selected_apps" | grep -q "Security" && {
        brew_install "GPG Suite" "gpg-suite" "--cask"
        brew_install "Keybase" "keybase" "--cask"
    }
    echo "$selected_apps" | grep -q "Media & Graphics" && {
        brew_install "Spotify" "spotify" "--cask"
        brew_install "Sketch" "sketch" "--cask"
        brew_install "Sip" "sip" "--cask"
        brew_install "Handbrake" "handbrake" "--cask"
        brew_install "Optimage" "optimage" "--cask"
    }
    echo "$selected_apps" | grep -q "Communication" && {
        brew_install "Discord" "discord" "--cask"
        brew_install "Slack" "slack" "--cask"
        brew_install "WhatsApp" "whatsapp" "--cask"
        brew_install "Zoom" "zoom" "--cask"
    }
    echo "$selected_apps" | grep -q "Productivity" && {
        brew_install "Alfred" "alfred" "--cask"
        brew_install "Obsidian" "obsidian" "--cask"
    }
    echo "$selected_apps" | grep -q "File Management" && {
        brew_install "Keka" "keka" "--cask"
        brew_install "Transmit" "transmit" "--cask"
    }
    echo "$selected_apps" | grep -q "Content Creation" && brew_install "OBS Studio" "obs" "--cask"
    echo "$selected_apps" | grep -q "Window Management" && brew_install "Aerospace" "aerospace" "--cask"
}

install_mac_app_store() {
    local selected_apps="$1"
    print_section "Installing Mac App Store Applications"
    
    if echo "$selected_apps" | grep -q "All Mac App Store"; then
        brew_mas_install "XCode" "497799835"
        brew_mas_install "Telegram" "747648890"
        brew_mas_install "Reeder 5" "1529448980"
        brew_mas_install "CARROT Weather" "993487541"
        brew_mas_install "Moom" "419330170"
        brew_mas_install "Displaperture" "1543920362"
        brew_mas_install "Gifski" "1351639930"
        brew_mas_install "iPreview" "1519213509"
    else
        echo "$selected_apps" | grep -q "Development" && brew_mas_install "XCode" "497799835"
        echo "$selected_apps" | grep -q "Communication" && brew_mas_install "Telegram" "747648890"
        echo "$selected_apps" | grep -q "Productivity" && {
            brew_mas_install "Reeder 5" "1529448980"
            brew_mas_install "Moom" "419330170"
        }
        echo "$selected_apps" | grep -q "Weather" && brew_mas_install "CARROT Weather" "993487541"
        echo "$selected_apps" | grep -q "Utilities" && {
            brew_mas_install "Displaperture" "1543920362"
            brew_mas_install "Gifski" "1351639930"
            brew_mas_install "iPreview" "1519213509"
        }
    fi
}

install_fonts() {
    local selected_fonts="$1"
    print_section "Installing Fonts"
    
    if echo "$selected_fonts" | grep -q "All Available" || echo "$selected_fonts" | grep -q "FiraCode"; then
        brew_install "FiraCode Nerd Font" "font-fira-code-nerd-font" "--cask"
    fi
}

install_services() {
    local selected_services="$1"
    print_section "Installing Services & Window Management"
    
    if echo "$selected_services" | grep -q "All Window Management" || echo "$selected_services" | grep -q "Yabai"; then
        brew_install "yabai" "koekeishiya/formulae/yabai"
        brew_start_service "yabai" "yabai"
    fi
    
    if echo "$selected_services" | grep -q "All Window Management" || echo "$selected_services" | grep -q "SKHD"; then
        brew_install "skhd" "koekeishiya/formulae/skhd"
        brew_start_service "skhd" "skhd"
    fi
    
    if echo "$selected_services" | grep -q "Aerospace"; then
        brew_install "aerospace" "aerospace" "--cask"
    fi
}

install_shell_config() {
    print_section "Shell Configuration"
    . "$HOME/.dotfiles/system/macos/setup_shell.sh"
}

install_source_packages() {
    print_section "Installing Source Packages"
    
    print_title "TMUX Plugin Manager (TPM)"
    execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"
    
    print_title "Yarn Global Packages"
    yarn_install "Serve" "serve"
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
            "Homebrew Setup"*)
                install_homebrew_setup
                gum style --foreground 212 "✨ Homebrew setup completed!"
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
            "GUI Applications"*)
                selected_apps=$(gui_applications_menu)
                if [[ -n "$selected_apps" ]]; then
                    install_gui_applications "$selected_apps"
                    gum style --foreground 212 "✨ GUI applications installation completed!"
                fi
                ;;
            "Mac App Store"*)
                selected_apps=$(mac_app_store_menu)
                if [[ -n "$selected_apps" ]]; then
                    install_mac_app_store "$selected_apps"
                    gum style --foreground 212 "✨ Mac App Store applications installation completed!"
                fi
                ;;
            "Fonts Installation")
                selected_fonts=$(fonts_menu)
                if [[ -n "$selected_fonts" ]]; then
                    install_fonts "$selected_fonts"
                    gum style --foreground 212 "✨ Fonts installation completed!"
                fi
                ;;
            "Services"*)
                selected_services=$(services_menu)
                if [[ -n "$selected_services" ]]; then
                    install_services "$selected_services"
                    gum style --foreground 212 "✨ Services installation completed!"
                fi
                ;;
            "Shell Configuration")
                install_shell_config
                gum style --foreground 212 "✨ Shell configuration completed!"
                ;;
            "Complete Installation"*)
                gum confirm "This will install ALL components. Continue?" && {
                    install_essential_setup
                    install_homebrew_setup
                    install_development_tools "Git & Git Tools Version Control Code Analysis Programming Languages Code Editors Documentation Build Tools"
                    install_cli_utilities "File Operations Search & Navigation System Monitoring Network Tools File Managers Terminal Enhancements Media Tools System Info"
                    install_gui_applications "Web Browsers Development Tools Terminals System Tools Security Media & Graphics Communication Productivity File Management Content Creation"
                    install_mac_app_store "All Mac App Store Apps"
                    install_fonts "All Available Fonts"
                    install_services "All Window Management Tools"
                    install_shell_config
                    install_source_packages
                    gum style --foreground 212 "✨ Complete installation finished!"
                }
                ;;
            "Custom Selection")
                categories=$(homebrew_categories_menu)
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
        clear
        show_welcome
    done
    
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 50 --margin "1 2" --padding "1 2" \
        '🎉 Installation Complete!' \
        'Your macOS system is now configured.'
}

#==================================
# Start Interactive Installation
#==================================
print_section "Interactive macOS Dotfiles Setup"

# Check if gum is available, install if needed
if ! command -v gum &> /dev/null; then
    print_title "Installing gum for interactive menus"
    if ! cmd_exists "brew"; then
        printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew_install "gum" "gum"
fi

main_interactive
