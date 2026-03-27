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
        choice=$(gum choose --cursor="→ " --height=4 --header="Installation modes:" \
            "Interactive Installation" \
            "Complete Automatic Installation")
        
        case "$choice" in
            "Interactive Installation")
                echo "interactive"
                ;;
            *)
                echo "automatic"
                ;;
        esac
    else
        # Fallback to text menu if gum is not available (Alpine might not have gum)
        print_section "Alpine Linux Dotfiles Setup"
        print_title "Choose Installation Mode"
        
        print_option "1" "Interactive Installation (Simplified - Essential components with text menus)"
        print_option "2" "Complete Automatic Installation (Install everything)"
        
        printf "\n"
        print_question "Which installation mode would you prefer? (1/2) "
        read -r choice
        
        case $choice in
            1)
                echo "interactive"
                ;;
            *)
                echo "automatic"
                ;;
        esac
    fi
}

run_interactive_installation() {
    if [[ -f "$HOME/.dotfiles/system/alpine/install_interactive.sh" ]]; then
        . "$HOME/.dotfiles/system/alpine/install_interactive.sh"
    else
        print_error "Interactive installation script not found!"
        print_warning "Falling back to automatic installation..."
        run_automatic_installation
    fi
}

run_automatic_installation() {
    print_section "Running Complete Alpine Installation"

    # setup symlinks
    . "$HOME/.dotfiles/system/symlink.sh"

    # setup packages
    . "$HOME/.dotfiles/system/alpine/setup_packages.sh"

    # setup shell
    . "$HOME/.dotfiles/system/alpine/setup_shell.sh"

    print_success "Complete installation finished!"
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
        *)
            run_automatic_installation
            ;;
    esac
else
    # Run automatic installation if no interactive mode or explicitly disabled
    run_automatic_installation
fi
