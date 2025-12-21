#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_arch.sh"

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
        if pacman_install "gum" "gum" >/dev/null 2>&1; then
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
    clear
    
    # Try to install gum first for beautiful menus
    install_gum_if_needed >/dev/null 2>&1

    local choice
    if command -v gum &> /dev/null; then
        gum style \
            --foreground 212 --border-foreground 212 --border rounded \
            --align center --width 60 --margin "1 2" --padding "1 2" \
            'Arch Linux Dotfiles Setup' \
            'Choose Installation Mode'

        gum style \
            --foreground 241 --align center --width 60 --margin "0 2" \
            'Select your preferred installation method'

        choice=$(gum choose --cursor="→ " --height=5 --header="Installation modes:" \
            "1. Interactive Installation" \
            "2. Complete Automatic Installation" \
            "3. Traditional Mode")
        
        case "$choice" in
            "1. Interactive Installation")
                echo "interactive"
                ;;
            "2. Complete Automatic Installation")
                echo "automatic"
                ;;
            "3. Traditional Mode")
                echo "traditional"
                ;;
            *)
                echo "traditional"
                ;;
        esac
    else
        # Fallback to text menu if gum is not available
        print_section "Arch Dotfiles Setup"
        print_title "Choose Installation Mode"
        
        print_option "1" "Interactive Installation (Recommended - pacman, AUR, Flatpak menus)"
        print_option "2" "Complete Automatic Installation (Install everything)"
        print_option "3" "Traditional Mode (Original behavior)"
        
        printf "\n"
        print_question "Which installation mode would you prefer? (1/2/3) "
        read -r text_choice
        
        case $text_choice in
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
    fi
}

run_interactive_installation() {
    # First try to install gum if needed
    if install_gum_if_needed; then
        if [[ -f "$HOME/.dotfiles/system/arch/install_interactive.sh" ]]; then
            . "$HOME/.dotfiles/system/arch/install_interactive.sh"
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
    print_section "Running Complete Arch Installation"
    print_warning "This will install ALL available packages, tools, and configurations."
    
    ask_for_confirmation "Continue with complete installation?"
    if answer_is_yes; then
        # setup symlinks
        . "$HOME/.dotfiles/system/symlink.sh"
        
        # setup packages
        . "$HOME/.dotfiles/system/arch/setup_packages.sh"
        
        # setup fonts
        . "$HOME/.dotfiles/system/arch/setup_fonts.sh"
        
        # setup defaults
        . "$HOME/.dotfiles/system/arch/setup_defaults.sh"
        
        # setup shell
        . "$HOME/.dotfiles/system/arch/setup_shell.sh"
        
        print_success "Complete installation finished!"
    else
        print_warning "Installation cancelled by user"
        exit 0
    fi
}

run_traditional_installation() {
    print_section "Running Arch Dotfiles Setup"

    # setup symlinks
    . "$HOME/.dotfiles/system/symlink.sh"

    # setup packages
    . "$HOME/.dotfiles/system/arch/setup_packages.sh"

    # setup fonts
    . "$HOME/.dotfiles/system/arch/setup_fonts.sh"

    # setup defaults
    . "$HOME/.dotfiles/system/arch/setup_defaults.sh"

    # setup shell
    . "$HOME/.dotfiles/system/arch/setup_shell.sh"
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
