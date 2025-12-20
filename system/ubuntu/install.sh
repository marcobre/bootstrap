#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_ubuntu.sh"

#==================================
# Check for Interactive Mode
#==================================
check_interactive_mode() {
    # Check if we're in an interactive environment
    # Be more permissive - only exclude clearly non-interactive cases
    if [[ "$TERM" == "dumb" ]] || [[ -n "$CI" ]] || [[ -n "$AUTOMATION" ]]; then
        return 1
    else
        return 0
    fi
}

install_gum_if_needed() {
    if ! command -v gum &> /dev/null; then
        print_title "Installing gum for interactive menus"
        
        # Add charm repository if not already added
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
        
        sudo apt update >/dev/null 2>&1
        if sudo apt install -y gum >/dev/null 2>&1; then
            print_success "gum installed successfully"
            return 0
        else
            print_error "Failed to install gum"
            return 1
        fi
    fi
    return 0
}

ask_installation_mode() {
    print_section "Ubuntu Dotfiles Setup"
    print_title "Choose Installation Mode"
    
    print_option "1" "Interactive Installation (Recommended - Select components with beautiful menus)"
    print_option "2" "Complete Automatic Installation (Install everything)"
    print_option "3" "Traditional Mode (Original behavior)"
    
    printf "\n"
    print_question "Which installation mode would you prefer? (1/2/3) "
    read -r choice
    
    case $choice in
        1)
            echo "interactive"
            ;;
        2)
            echo "automatic"
            ;;
        3|*)
            echo "traditional"
            ;;
    esac
}

run_interactive_installation() {
    # First try to install gum if needed
    if install_gum_if_needed; then
        if [[ -f "$HOME/.dotfiles/system/ubuntu/install_interactive.sh" ]]; then
            . "$HOME/.dotfiles/system/ubuntu/install_interactive.sh"
        else
            print_error "Interactive installation script not found!"
            print_warning "Falling back to traditional installation..."
            run_traditional_installation
        fi
    else
        print_warning "Could not install gum. Falling back to traditional installation..."
        run_traditional_installation
    fi
}

run_automatic_installation() {
    print_section "Running Complete Ubuntu Installation"
    print_warning "This will install ALL available packages, tools, and configurations."
    
    ask_for_confirmation "Continue with complete installation?"
    if answer_is_yes; then
        # setup symlinks
        . "$HOME/.dotfiles/system/symlink.sh"
        
        # setup packages
        . "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"
        
        # setup fonts
        . "$HOME/.dotfiles/system/ubuntu/setup_fonts.sh"
        
        # setup defaults
        . "$HOME/.dotfiles/system/ubuntu/setup_defaults.sh"
        
        # setup shell
        . "$HOME/.dotfiles/system/ubuntu/setup_shell.sh"
        
        print_success "Complete installation finished!"
    else
        print_warning "Installation cancelled by user"
        exit 0
    fi
}

run_traditional_installation() {
    print_section "Running Ubuntu Dotfiles Setup"

    # setup symlinks
    . "$HOME/.dotfiles/system/symlink.sh"

    # setup packages
    . "$HOME/.dotfiles/system/ubuntu/setup_packages.sh"

    # setup fonts
    . "$HOME/.dotfiles/system/ubuntu/setup_fonts.sh"

    # setup defaults
    . "$HOME/.dotfiles/system/ubuntu/setup_defaults.sh"

    # setup shell
    . "$HOME/.dotfiles/system/ubuntu/setup_shell.sh"
}

#==================================
# Main Installation Logic
#==================================

# Check if we should run in interactive mode
if check_interactive_mode && [[ "${1:-}" != "--no-interactive" ]]; then
    # Ask user for installation mode preference
    mode=$(ask_installation_mode)
    
    case $mode in
        "interactive")
            run_interactive_installation
            ;;
        "automatic")
            run_automatic_installation
            ;;
        "traditional"|*)
            run_traditional_installation
            ;;
    esac
else
    # Run traditional installation if no interactive mode or explicitly disabled
    run_traditional_installation
fi
