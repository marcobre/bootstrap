#!/bin/bash

#==================================
# SOURCE UTILS
#==================================
cd "$(dirname "${BASH_SOURCE[0]}")" && . "utils.sh"

#==================================
# BREW
#==================================
# Put Homebrew on PATH for the *current* shell. Idempotent.
# The setup runs in a single bash session, so this must be called directly,
# never through `execute` (which runs in a background subshell).
ensure_brew_in_path() {
    local brew_bin
    for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [[ -x "$brew_bin" ]]; then
            # Always eval: /etc/paths.d/homebrew puts brew *after* /usr/bin,
            # shellenv moves it to the front (and prints nothing if already there).
            eval "$("$brew_bin" shellenv bash)"
            hash -r
            return 0
        fi
    done
    return 1
}

# Install Homebrew unattended (if missing) and make it usable in this session.
install_homebrew() {
    if ensure_brew_in_path; then
        print_success "Homebrew (already installed)"
        return 0
    fi

    # Refresh the sudo timestamp: in NONINTERACTIVE mode the installer uses `sudo -n`
    sudo -v
    NONINTERACTIVE=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    ensure_brew_in_path
    print_result $? "Homebrew"
}

brew_install() {
    declare -r ARGUMENTS="$3"
    declare -r FORMULA="$2"
    declare -r FORMULA_READABLE_NAME="$1"
    declare -r TAP_VALUE="$4"

    # Check if `Homebrew` is installed.
    if ! cmd_exists "brew"; then
        print_error "$FORMULA_READABLE_NAME ('Homebrew' is not installed)"
        return 1
    fi

    # If `brew tap` needs to be executed,
    # check if it executed correctly.
    if [ -n "$TAP_VALUE" ]; then
        if ! brew_tap "$TAP_VALUE"; then
            print_error "$FORMULA_READABLE_NAME ('brew tap $TAP_VALUE' failed)"
            return 1
        fi
    fi

    # Install the specified formula.
    # shellcheck disable=SC2086
    if brew list "$FORMULA" &> /dev/null; then
        print_success "$FORMULA_READABLE_NAME"
    else
        execute \
            "brew install $FORMULA $ARGUMENTS" \
            "$FORMULA_READABLE_NAME"
    fi
}

brew_mas_install() {
    declare -r ARGUMENTS="$3"
    declare -r MASID="$2"
    declare -r MASID_READABLE_NAME="$1"

    # Check if `Homebrew` is installed.
    if ! cmd_exists "brew"; then
        print_error "$MASID_READABLE_NAME ('Homebrew' is not installed)"
        return 1
    fi

    # Install the specified MASID.
    # shellcheck disable=SC2086
    if brew list "$MASID" &> /dev/null; then
        print_success "$MASID_READABLE_NAME"
    else
        execute \
            "mas install $MASID $ARGUMENTS" \
            "$MASID_READABLE_NAME"
    fi
}

brew_prefix() {
    local path=""

    if path="$(brew --prefix 2> /dev/null)"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Homebrew (get prefix)"
        return 1
    fi
}

# Non-official taps used by the macOS setup. Since Homebrew 6.0, non-official taps
# must be trusted before brew loads them (https://docs.brew.sh/Tap-Trust).
# Official taps (homebrew/core, cask, bundle, cask-versions, cask-fonts) are not
# needed anymore: core/cask load from the API, bundle is built in, and
# cask-versions/cask-fonts were merged into homebrew/cask.
BREW_TRUSTED_TAPS=(
    "d12frosted/emacs-plus"   # emacs-plus
    "teamookla/speedtest"     # speedtest
    "nikitabobko/tap"         # aerospace
    "asmvik/formulae"         # yabai, skhd (formerly koekeishiya/formulae)
)

# Trust and tap a non-official tap. Trust comes first: `brew tap` evaluates every
# formula/cask of the tap before accepting it, which fails for untrusted taps.
brew_tap() {
    brew trust "$1" &> /dev/null && brew tap "$1" &> /dev/null
}

# Trust and tap everything in BREW_TRUSTED_TAPS
brew_setup_taps() {
    local tap
    for tap in "${BREW_TRUSTED_TAPS[@]}"; do
        brew_tap "$tap"
        print_result $? "Trust & tap $tap"
    done
}

brew_update() {
    execute \
        "brew update" \
        "Homebrew (Update)"
}

brew_upgrade() {
    execute \
        "brew upgrade" \
        "Homebrew (Upgrade)"
}

brew_start_service() {
    declare -r SERVICE="$2"
    declare -r SERVICE_READABLE_NAME="$1"

	execute \
		"brew services start $SERVICE" \
		"Brew Service Starting: $SERVICE_READABLE_NAME"
}


#==================================
# YARN
#==================================
yarn_install() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    # Install the specified formula.
    # shellcheck disable=SC2086
    if yarn global list "$FORPACKAGEMULA" &> /dev/null; then
        print_success "$PACKAGE_READABLE_NAME"
    else
		execute \
			"yarn global add  $PACKAGE" \
			"$PACKAGE_READABLE_NAME"
	fi
}


#==================================
# FISHER
#==================================
fisher_install() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    fish -c "fisher install $PACKAGE" &> /dev/null
    print_result $? "$PACKAGE_READABLE_NAME" "true"
}