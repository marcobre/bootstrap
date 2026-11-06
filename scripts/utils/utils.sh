#!/bin/bash

#==================================
# OS Check
#==================================
get_os() {
    local os=""
    local kernelName=""
    kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ] && [ -e "/etc/os-release" ]; then
        os="$(. /etc/os-release; printf "%s" "$ID")"

        if grep -qi "Microsoft" /proc/version; then            
            if grep -qi "Microsoft" /proc/version && [ "$os" == "ubuntu" ]; then
                os="wsl_ubuntu"
            else
                 os="$kernelName" 
            fi
        elif [ "$os" == "alpine" ] && [ -e "/etc/alpine-release" ]; then
            os="alpine"
        elif [ "$os" == "cachyos" ]; then
            os="arch"  # CachyOS uses Arch system folder
        fi
    else
        os="$kernelName"
    fi

    printf "%s" "$os"
}

get_os_version() {
    local os=""
    local version=""
    os="$(get_os)"

    if [ "$os" == "macos" ]; then
        version="$(sw_vers -productVersion)"
    elif [ -e "/etc/os-release" ]; then
        version="$(. /etc/os-release; printf "%s" "$VERSION_ID")"
    fi

    printf "%s" "$version"
}

is_supported_version() {
    # shellcheck disable=SC2206
    declare -a v1=(${1//./ })
    # shellcheck disable=SC2206
    declare -a v2=(${2//./ })
    local i=""

    # Fill empty positions in v1 with zeros.
    for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
        v1[i]=0
    done

    for (( i=0; i<${#v1[@]}; i++ )); do
        # Fill empty positions in v2 with zeros.
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi

        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            return 1
        elif (( 10#${v1[i]} > 10#${v2[i]} )); then
            return 0
        fi
    done
}

#==================================
# Ask
#==================================
ask_for_sudo() {
    print_question "Setup requires sudo access "

    # Ask for the administrator password upfront.
    sudo -v &> /dev/null

    # Update existing `sudo` time stamp
    # until this script has finished.
    #
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &
}

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read -r
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -r -n 1
    printf "\n"
}

#==================================
# Get
#==================================
get_answer() {
    printf "%s" "$REPLY"
}

cmd_exists() {
    command -v "$1" &> /dev/null
}

is_git_repository() {
    git rev-parse &> /dev/null
}

repo_has_remote_url() {
    git config --get remote.origin.url  &> /dev/null
}

#==================================
# Release Binaries
#==================================
# Install the latest lazygit release binary into /usr/local/bin (Linux).
# Used where the distro has no lazygit package. Verifies the SHA-256 checksum,
# works in a temp dir (no `cd` in the shared shell) and cleans up after itself.
install_lazygit_release() {
    local arch version base tarball tmp_dir exit_code

    case "$(uname -m)" in
        x86_64)        arch="x86_64" ;;
        aarch64|arm64) arch="arm64" ;;
        armv6l|armv7l) arch="armv6" ;;
        i?86)          arch="32-bit" ;;
        *)
            print_error "lazygit (unsupported architecture: $(uname -m))"
            return 1
            ;;
    esac

    # sed instead of `grep -P`, so this also works with busybox (Alpine)
    version="$(curl -fsSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
        | sed -nE 's/.*"tag_name": *"v([^"]+)".*/\1/p')"
    if [ -z "$version" ]; then
        print_error "lazygit (could not determine the latest version)"
        return 1
    fi

    base="https://github.com/jesseduffield/lazygit/releases/download/v${version}"
    tarball="lazygit_${version}_linux_${arch}.tar.gz"
    tmp_dir="$(mktemp -d)"

    execute \
        "curl -fsSL -o '$tmp_dir/$tarball' '$base/$tarball' \
        && curl -fsSL -o '$tmp_dir/checksums.txt' '$base/checksums.txt' \
        && (cd '$tmp_dir' && grep ' $tarball\$' checksums.txt | sha256sum -c -) \
        && tar -xzf '$tmp_dir/$tarball' -C '$tmp_dir' lazygit \
        && sudo install -m 755 '$tmp_dir/lazygit' /usr/local/bin/lazygit" \
        "lazygit $version"
    exit_code=$?

    rm -rf "$tmp_dir"
    return $exit_code
}

#==================================
# Nerd Fonts
#==================================
# GitHub's `releases/latest/download/<asset>` always serves the latest release,
# so no version lookup (GitHub API + jq) is needed.
NERD_FONTS_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download"

# Install one Nerd Font (latest release) into ~/.local/share/fonts (Linux).
# Requires curl and unzip; callers install them with their package manager.
install_nerd_font() {
    local font="$1"
    local fonts_dir="${2:-$HOME/.local/share/fonts}"
    local tmp_file exit_code

    mkdir -p "$fonts_dir"
    tmp_file="$(mktemp)"

    execute \
        "curl -fsSL -o '$tmp_file' '$NERD_FONTS_URL/$font.zip' \
        && unzip -qq -o '$tmp_file' -d '$fonts_dir'" \
        "$font"
    exit_code=$?

    rm -f "$tmp_file"
    return $exit_code
}

# Refresh the font cache after installing fonts. Requires fontconfig (fc-cache).
update_font_cache() {
    local fonts_dir="${1:-$HOME/.local/share/fonts}"

    # "Windows Compatible" variants only exist in older Nerd Fonts releases
    find "$fonts_dir" -name '*Windows Compatible*' -delete 2> /dev/null
    execute "fc-cache -f '$fonts_dir'" "Update font cache"
}

#==================================
# Shell Plugin Managers
#==================================
# Canonical sources instead of the deprecated git.io short links
# (git.io/antigen → antigen master, git.io/fisher → fisher HEAD).
ANTIGEN_URL="https://github.com/zsh-users/antigen/releases/latest/download/antigen.zsh"
FISHER_URL="https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish"

# Download Antigen to ~/.config/antigen.zsh (sourced by config/zsh/.zshrc).
# Downloads to a temp file first, so a failed download never replaces a working
# copy with an empty file or an HTML error page.
install_antigen() {
    local target="$HOME/.config/antigen.zsh"
    local tmp_file exit_code

    mkdir -p "$HOME/.config"
    tmp_file="$(mktemp "$target.XXXXXX")"

    execute \
        "curl -fsSL -o '$tmp_file' '$ANTIGEN_URL' \
        && [ -s '$tmp_file' ] \
        && mv -f '$tmp_file' '$target'" \
        "Antigen"
    exit_code=$?

    rm -f "$tmp_file"
    return $exit_code
}

# Install Fisher into fish, as documented upstream. Re-running is safe:
# `fisher install` on an installed plugin updates it.
install_fisher() {
    if ! cmd_exists "fish"; then
        print_error "Fisher (fish is not installed)"
        return 1
    fi

    execute \
        "fish -c 'curl -fsSL $FISHER_URL | source && fisher install jorgebucaran/fisher'" \
        "Fisher"
}

#==================================
# Symlink
#==================================
# Link $1 to $2. `-n` treats an existing link at $2 as a file and replaces it;
# without it, re-linking a folder (e.g. config/sketchybar) would follow the old
# link and create a stray link *inside* the repo folder.
symlink() {
    mkdir -p "$(dirname "$2")"
    execute "ln -sfn '$1' '$2'" "$(basename "$1")    →    $2"
}

open_dir() {
    # The order of the following checks matters
    # as on Ubuntu there is also a utility called `open`.
    if cmd_exists "xdg-open"; then
        xdg-open "$1"
    elif cmd_exists "open"; then
        open "$1"
    else
        print_warning "Can't open $1"
    fi

}

#==================================
# Print
#==================================
print_section() {
    local TITLE="$*"
    local TITLE_LENGTH=${#TITLE}
    local BORDER_LENGTH=$((TITLE_LENGTH + 18))

    local i
    local BANNER_TOP
    for (( i = 0; i < BORDER_LENGTH; ++i )); do
        if [ $i = 0 ]; then
            BANNER_TOP+="╭"
        elif [ $i = $(($BORDER_LENGTH-1)) ]; then
            BANNER_TOP+="╮"
        else
            BANNER_TOP+="─"
        fi
    done

    local BANNER_BOTTOM
    for (( i = 0; i < BORDER_LENGTH; ++i )); do
        if [ $i = 0 ]; then
            BANNER_BOTTOM+="╰"
        elif [ $i = $(($BORDER_LENGTH-1)) ]; then
            BANNER_BOTTOM+="╯"
        else
            BANNER_BOTTOM+="─"
        fi
    done

    print_linke_break
    print_in_green "$BANNER_TOP"
    print_in_green "\n│        $TITLE        │\n"
    print_in_green "$BANNER_BOTTOM"
    print_linke_break

}

print_title() {
    print_in_color "\n • $1\n" 5
}

print_success() {
    print_in_green "   [✔] $1\n"
}

print_warning() {
    print_in_yellow "   [!] $1\n"
}

print_error() {
    print_in_red "   [✖] $1 $2\n"
}

print_question() {
    print_in_yellow "   [?] $1"
}

print_option() {
    print_in_yellow "   $1)"
    print_in_white " $2\n"
}

print_result() {
    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"
}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}

print_in_white() {
    print_in_color "$1" 7
}

print_in_green() {
    print_in_color "$1" 2
}

print_in_purple() {
    print_in_color "$1" 5
}

print_in_red() {
    print_in_color "$1" 1
}

print_in_yellow() {
    print_in_color "$1" 3
}

print_in_blue() {
    print_in_color "$1" 4
}

print_linke_break() {
    printf "\n"
}

print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

#==================================
# Process
#==================================
execute() {

    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    local exitCode=0
    local cmdsPID=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Execute commands in background
    # shellcheck disable=SC2261

    eval "$CMDS" \
        &> /dev/null \
        2> "$TMP_FILE" &

    cmdsPID=$!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Show a spinner if the commands
    # require more time to complete.

    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened.

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    return $exitCode

}

kill_all_subprocesses() {
    local i=""

    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &> /dev/null
    done
}

set_trap() {
    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"
}

show_spinner() {
    local -r FRAMES='⡿⣟⣯⣷⣾⣽⣻⢿'

    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    local i=0
    local frameText=""

    # Display spinner while the commands are being executed.
    while kill -0 "$PID" &>/dev/null; do
        frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

        # Print frame text.
        printf "%s" "$frameText"
        sleep 0.2
        printf "\r"
    done
}
