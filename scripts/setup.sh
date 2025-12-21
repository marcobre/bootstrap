#!/bin/bash

#==================================
# Variables
#==================================
declare GITHUB_REPOSITORY="marcobre/bootstrap"
declare DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/main"
declare DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/main/scripts/utils/utils.sh"

#==================================
# Settings
#==================================
declare DOTFILES_DIR="$HOME/.dotfiles"
declare MINIMUM_MACOS_VERSION="12.0"
declare MINIMUM_UBUNTU_VERSION="20.04"

#==================================
# Helper Functions
#==================================
download() {
  local url="$1"
  local output="$2"

  if command -v "curl" &>/dev/null; then
    curl \
      --location \
      --silent \
      --show-error \
      --output "$output" \
      "$url" \
      &>/dev/null

    return $?

  elif command -v "wget" &>/dev/null; then
    wget \
      --quiet \
      --output-document="$output" \
      "$url" \
      &>/dev/null

    return $?
  fi

  return 1
}

download_dotfiles() {
  local tmpFile=""

  print_title "Download and extract archive"
  tmpFile="$(mktemp /tmp/XXXXX)"

  download "$DOTFILES_TARBALL_URL" "$tmpFile"
  print_result $? "Download archive" "true"

  mkdir -p "$DOTFILES_DIR"
  print_result $? "Create '$DOTFILES_DIR'" "true"

  # Extract archive in the `dotfiles` directory.
  extract "$tmpFile" "$DOTFILES_DIR"
  print_result $? "Extract archive" "true"

  rm -rf "$tmpFile"
  print_result $? "Remove archive"
}

download_utils() {
  local tmpFile=""

  tmpFile="$(mktemp /tmp/XXXXX)"
  download "$DOTFILES_UTILS_URL" "$tmpFile" &&
    . "$tmpFile" &&
    rm -rf "$tmpFile" &&
    return 0

  return 1

}

extract() {
  local archive="$1"
  local outputDir="$2"

  if command -v "tar" &>/dev/null; then
    tar \
      --extract \
      --gzip \
      --file "$archive" \
      --strip-components 1 \
      --directory "$outputDir"

    return $?
  fi

  return 1
}

verify_os() {
  local os_name="$(get_os)"
  local os_version="$(get_os_version)"

  # Check if the OS is `macOS` and supported
  if [ "$os_name" == "macos" ]; then
    if is_supported_version "$os_version" "$MINIMUM_MACOS_VERSION"; then
      print_success "$os_name $os_version is supported"
      return 0
    else
      print_error "Minimum MacOS $MINIMUM_MACOS_VERSION is required (current is $os_version)"
    fi

  # Check if the OS is `Ubuntu` and supported
  elif [ "$os_name" == "ubuntu" ]; then

    if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
      print_success "$os_name $os_version is supported"
      return 0
    else
      print_error "Minimum Ubuntu $MINIMUM_UBUNTU_VERSION is required (current is $os_version)"
    fi

  # Check if the OS is `Windows WSL` and supported
  elif [ "$os_name" == "wsl_ubuntu" ]; then
    print_success "Windows WSL on Ubuntu is supported"
    return 0

  # Check if the OS is `Arch` and supported
  elif [ "$os_name" == "arch" ]; then
    print_success "$os_name is supported"
    return 0

  # Check if the OS is `Alpine` and supported
  elif [ "$os_name" == "alpine" ]; then
    print_success "$os_name is supported"
    return 0

  # Exit if not supported OS
  else
    print_error "$os_name is not supported. This dotfiles are intended for MacOS, Ubuntu and Arch"
  fi

  return 1
}

install_gum_if_needed() {
  if ! command -v gum &> /dev/null; then
    print_title "Installing gum for interactive menus"
    
    local os_name="$(get_os)"
    
    case "$os_name" in
      "ubuntu"|"wsl_ubuntu")
        # Ubuntu/WSL Ubuntu - use wget for GPG key download
        sudo apt update >/dev/null 2>&1
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg --yes 2>/dev/null
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
        sudo apt update >/dev/null 2>&1
        if sudo apt install -y gum >/dev/null 2>&1; then
          print_success "gum installed successfully"
          return 0
        else
          print_error "Failed to install gum via apt"
          return 1
        fi
        ;;
      "macos")
        # macOS - use wget if available, otherwise install homebrew which includes curl
        if ! command -v brew &> /dev/null; then
          if command -v wget &> /dev/null; then
            printf "\n" | /bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          else
            # Fallback to curl if wget not available on macOS
            printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
          fi
        fi
        if brew install gum >/dev/null 2>&1; then
          print_success "gum installed successfully"
          return 0
        else
          print_error "Failed to install gum via brew"
          return 1
        fi
        ;;
      "arch")
        # Arch Linux - use pacman directly
        if sudo pacman -S --noconfirm gum >/dev/null 2>&1; then
          print_success "gum installed successfully"
          return 0
        else
          print_error "Failed to install gum via pacman"
          return 1
        fi
        ;;
      "alpine")
        # Alpine Linux - try apk directly
        if sudo apk add --no-cache gum >/dev/null 2>&1; then
          print_success "gum installed successfully"
          return 0
        else
          print_warning "gum not available via apk, interactive menus will be text-based"
          return 1
        fi
        ;;
      *)
        print_warning "Unknown OS for gum installation, interactive menus may not work"
        return 1
        ;;
    esac
  fi
  return 0
}

#==================================
# Check if running remotely
#==================================
is_remote_execution() {
  # Check if we're running from a remote context (piped from wget/curl)
  # This happens when stdin is not a terminal AND we're running from a temp location
  if [[ ! -t 0 ]] && [[ "${BASH_SOURCE[0]}" =~ ^/tmp/ || "${BASH_SOURCE[0]}" =~ ^/dev/fd/ || "${BASH_SOURCE[0]}" =~ ^/proc/self/fd/ ]]; then
    return 0
  fi
  return 1
}

#==================================
# Main Install Starter
#==================================
main() {

  # Ensure that the following actions are made relative to this file's path.
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

  # Load utils
  if [ -x "utils.sh" ]; then
    . "utils.sh" || exit 1
  else
    download_utils || exit 1
  fi

  print_section "Marcom Dotfiles Setup"

  # Ask user for sudo
  print_title "Sudo Access"
  ask_for_sudo

  # Verify OS and OS version
  print_title "Verifying OS"
  verify_os || exit 1

  # Check if this script was run directly (./<path>/setup.sh),
  # and if not, it most likely means that the dotfiles were not
  # yet set up, and they will need to be downloaded.
  printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &>/dev/null ||
    download_dotfiles

  # Install gum for interactive menus before starting OS-specific installation
  install_gum_if_needed

  # Start installation
  . "$HOME/.dotfiles/system/$(get_os)/install.sh"

  # Ask for git credentials
  . "$HOME/.dotfiles/scripts/utils/generate_git_creds.sh"

  # Ask for SSH (Disabled since I started using another method)
  #. "$HOME/.dotfiles/scripts/utils/generate_ssh.sh"

  # Ask for GPG (Disabled since I started using another method)
  #. "$HOME/.dotfiles/scripts/utils/generate_gpg.sh"

  # Link to original repository and update contents of dotfiles
  #    if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
  #        . "$HOME/.dotfiles/scripts/utils/init_dotfile_repo.sh '$DOTFILES_ORIGIN'"
  #    fi

  # Ask for restart
  . "$HOME/.dotfiles/scripts/utils/restart.sh"
}

main "$@"
