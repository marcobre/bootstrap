#!/bin/bash

#==================================
# SOURCE UTILS
#==================================
cd "$(dirname "${BASH_SOURCE[0]}")" && . "utils.sh"

#==================================
# BREW
#==================================
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

brew_tap() {
    brew tap "$1" &> /dev/null
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