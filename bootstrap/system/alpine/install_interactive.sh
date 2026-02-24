#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_alpine.sh"

#==================================
# Interactive Menu Functions
#==================================

show_welcome() {
    clear
    gum style \
        --foreground 212 --border-foreground 212 --border rounded \
        --align center --width 60 --margin "1 2" --padding "1 2" \
        'Welcome to Marcom Dotfiles Setup' \
        'Interactive Alpine Linux Installation'

    gum style \
        --foreground 241 --align center --width 60 --margin "0 2" \
        'This interactive installer will help you customize your Alpine setup' \
        'Focused on essential tools for a minimal system'
}

main_menu() {
    local choice
    choice=$(gum choose --cursor="→ " --height=10 --header="Select installation components:" \
        "Essential Setup (Symlinks)" \
        "System Updates" \
        "Development Tools" \
        "CLI Utilities" \
        "Network Tools" \
        "Shell Configuration" \
        "Complete Installation (All Components)" \
        "Custom Selection" \
        "Exit")
    echo "$choice"
}

development_tools_menu() {
    gum choose --no-limit --cursor="→ " --height=10 --header="Select development tools:" \
        "Git (Version Control)" \
        "Python3 (Programming Language)" \
        "JQ (JSON Processor)" \
        "Neovim (Text Editor)" \
        "LazyGit (Git TUI)" \
        "TMUX (Terminal Multiplexer)"
}

cli_utilities_menu() {
    gum choose --no-limit --cursor="→ " --height=12 --header="Select CLI utilities:" \
        "File Operations (exa, bat, less)" \
        "Search & Navigation (fzf, ripgrep, fasd)" \
        "System Monitoring (htop)" \
        "System Information (neofetch, tldr)" \
        "All Essential CLI Tools"
}

network_tools_menu() {
    gum choose --no-limit --cursor="→ " --height=8 --header="Select network tools:" \
        "Basic Tools (curl, wget)" \
        "HTTP Client (httpie)" \
        "Network Diagnostics (prettyping)" \
        "All Network Tools"
}

#==================================
# Installation Functions
#==================================

install_essential_setup() {
    print_section "Essential Setup"
    
    print_title "Creating Symlinks"
    . "$HOME/.dotfiles/system/symlink.sh"
}

install_system_updates() {
    print_section "System Updates"
    
    print_title "Update Package Index"
    apk_update
}

install_development_tools() {
    local selected_tools="$1"
    print_section "Installing Development Tools"
    
    echo "$selected_tools" | grep -q "Git" && apk_install "git" "git"
    echo "$selected_tools" | grep -q "Python3" && apk_install "python3" "python3"
    echo "$selected_tools" | grep -q "JQ" && apk_install "jq" "jq"
    echo "$selected_tools" | grep -q "Neovim" && apk_install "neovim" "neovim"
    echo "$selected_tools" | grep -q "TMUX" && apk_install "tmux" "tmux"
    
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
    
    if echo "$selected_utils" | grep -q "All Essential" || echo "$selected_utils" | grep -q "File Operations"; then
        apk_install "exa" "exa"
        apk_install "bat" "bat"  
        apk_install "less" "less"
    fi
    
    if echo "$selected_utils" | grep -q "All Essential" || echo "$selected_utils" | grep -q "Search"; then
        apk_install "fzf" "fzf"
        apk_install "ripgrep" "ripgrep"
        apk_install "fasd" "fasd"
    fi
    
    if echo "$selected_utils" | grep -q "All Essential" || echo "$selected_utils" | grep -q "System Monitoring"; then
        apk_install "htop" "htop"
    fi
    
    if echo "$selected_utils" | grep -q "All Essential" || echo "$selected_utils" | grep -q "System Information"; then
        apk_install "neofetch" "neofetch"
        apk_install "tldr" "tldr"
    fi
}

install_network_tools() {
    local selected_tools="$1"
    print_section "Installing Network Tools"
    
    if echo "$selected_tools" | grep -q "All Network" || echo "$selected_tools" | grep -q "Basic Tools"; then
        apk_install "curl" "curl"
        apk_install "wget" "wget"
    fi
    
    if echo "$selected_tools" | grep -q "All Network" || echo "$selected_tools" | grep -q "HTTP Client"; then
        apk_install "httpie" "httpie"
    fi
    
    if echo "$selected_tools" | grep -q "All Network" || echo "$selected_tools" | grep -q "Network Diagnostics"; then
        apk_install "prettyping" "prettyping"
    fi
}

install_shell_config() {
    print_section "Shell Configuration"
    . "$HOME/.dotfiles/system/alpine/setup_shell.sh"
}

install_source_packages() {
    print_section "Installing Source Packages"
    
    print_title "TMUX Plugin Manager (TPM)"
    rm -rf ~/.tmux/plugins/tpm
    execute "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" "TMUX Plugin Manager (TPM)"
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
            "System Updates")
                install_system_updates
                gum style --foreground 212 "✨ System updates completed!"
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
            "Network Tools")
                selected_tools=$(network_tools_menu)
                if [[ -n "$selected_tools" ]]; then
                    install_network_tools "$selected_tools"
                    gum style --foreground 212 "✨ Network tools installation completed!"
                fi
                ;;
            "Shell Configuration")
                install_shell_config
                gum style --foreground 212 "✨ Shell configuration completed!"
                ;;
            "Complete Installation"*)
                gum confirm "This will install ALL available components. Continue?" && {
                    install_essential_setup
                    install_system_updates
                    install_development_tools "Git Python3 JQ Neovim LazyGit TMUX"
                    install_cli_utilities "All Essential CLI Tools"
                    install_network_tools "All Network Tools"
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
        'Your Alpine Linux system is now configured.'
}

#==================================
# Start Interactive Installation
#==================================
print_section "Interactive Alpine Dotfiles Setup"

# Check if gum is available, install if needed
if ! command -v gum &> /dev/null; then
    print_title "Installing gum for interactive menus"
    # Alpine doesn't have gum in repositories, try to install from source
    print_warning "Gum not available in Alpine repositories"
    print_warning "Falling back to basic text-based menus"
    
    # For now, we'll show a simplified menu without gum
    print_section "Alpine Dotfiles Setup - Text Mode"
    print_title "Available Installation Options:"
    print_option "1" "Complete Installation (Recommended)"
    print_option "2" "Development Tools Only"
    print_option "3" "CLI Utilities Only"
    print_option "4" "Exit"
    
    printf "\n"
    print_question "Select an option (1-4): "
    read -r choice
    
    case $choice in
        1)
            install_essential_setup
            install_system_updates
            install_development_tools "Git Python3 JQ Neovim LazyGit TMUX"
            install_cli_utilities "All Essential CLI Tools"
            install_network_tools "All Network Tools"
            install_shell_config
            install_source_packages
            print_success "Complete installation finished!"
            ;;
        2)
            install_development_tools "Git Python3 JQ Neovim LazyGit TMUX"
            print_success "Development tools installation completed!"
            ;;
        3)
            install_cli_utilities "All Essential CLI Tools"
            print_success "CLI utilities installation completed!"
            ;;
        4|*)
            print_warning "Installation cancelled"
            exit 0
            ;;
    esac
else
    main_interactive
fi
