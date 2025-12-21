#!/bin/bash
# shellcheck disable=SC1091

#==================================
# Source utilities
#==================================
. "$HOME/.dotfiles/scripts/utils/utils.sh"
. "$HOME/.dotfiles/scripts/utils/utils_alpine.sh"

#==================================
# Check for Interactive Mode
#==================================
check_interactive_mode() {
    # Check if we're in an interactive environment
    # Only disable interactive mode in clearly non-interactive contexts
    if [[ "$TERM" == "dumb" ]] || [[ -n "$CI" ]] || [[ -n "$AUTOMATION" ]]; then
        return 1
    else
        return 0
    fi
}

ask_installation_mode() {
    if command -v gum &> /dev/null; then
        gum style \
            --foreground 212 --border-foreground 212 --border rounded \
            --align center --width 60 --margin "1 2" --padding "1 2" \
            'Alpine Linux Dotfiles Setup' \
            'Choose Installation Mode'

        gum style \
            --foreground 241 --align center --width 60 --margin "0 2" \
            'Select your preferred installation method'

        local choice
        choice=$(gum choose --cursor="→ " --height=5 --header="Installation modes:" \
            "Interactive Installation" \
            "Complete Automatic Installation" \
            "Traditional Mode")
        
        case "$choice" in
            "Interactive Installation")
                echo "interactive"
                ;;
            "Complete Automatic Installation")
                echo "automatic"
                ;;
            "Traditional Mode")
                echo "traditional"
                ;;
            *)
                echo "traditional"
                ;;
        esac
    else
        # Fallback to text menu if gum is not available (Alpine might not have gum)
        print_section "Alpine Linux Dotfiles Setup"
        print_title "Choose Installation Mode"
        
        print_option "1" "Interactive Installation (Simplified - Essential components with text menus)"
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
    fi
}

run_interactive_installation() {
    if [[ -f "$HOME/.dotfiles/system/alpine/install_interactive.sh" ]]; then
        . "$HOME/.dotfiles/system/alpine/install_interactive.sh"
    else
        print_error "Interactive installation script not found!"
        print_warning "Falling back to traditional installation..."
        run_traditional_installation
    fi
}

run_automatic_installation() {
    print_section "Running Complete Alpine Installation"
    print_warning "This will install ALL available packages and configurations."
    
    ask_for_confirmation "Continue with complete installation?"
    if answer_is_yes; then
        # setup symlinks
        . "$HOME/.dotfiles/system/symlink.sh"
        
        # setup packages
        . "$HOME/.dotfiles/system/alpine/setup_packages.sh"
        
        # setup shell
        . "$HOME/.dotfiles/system/alpine/setup_shell.sh"
        
        print_success "Complete installation finished!"
    else
        print_warning "Installation cancelled by user"
        exit 0
    fi
}

run_traditional_installation() {
    print_section "Running Alpine Dotfiles Setup"

    # setup symlinks
    . "$HOME/.dotfiles/system/symlink.sh"

    # setup packages
    . "$HOME/.dotfiles/system/alpine/setup_packages.sh"

    # setup shell
    . "$HOME/.dotfiles/system/alpine/setup_shell.sh"
}

#==================================
# Main Installation Logic
#==================================

# Check if we should run in interactive mode
if check_interactive_mode && [[ "${1:-}" != "--no-interactive" ]]; then
    # Ask user for installation mode preference (gum may be installed by setup.sh)
    mode=$(ask_installation_mode)
    
    # Clean up the mode string to remove any extra characters
    mode=$(echo "$mode" | tr -d "'" | tr -d '#' | xargs)
    
    case $mode in
        *"interactive"*)
            run_interactive_installation
            ;;
        *"automatic"*)
            run_automatic_installation
            ;;
        *"traditional"*)
            run_traditional_installation
            ;;
        *)
            run_traditional_installation
            ;;
    esac
else
    # Run traditional installation if no interactive mode or explicitly disabled
    run_traditional_installation
fi
