#!/bin/bash

#==================================
# SOURCE UTILS
#==================================
cd "$(dirname "${BASH_SOURCE[0]}")" && . "utils.sh"


#==================================
# APT
#==================================
apt_add_key() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"
    execute "wget -qO - "$PACKAGE" | sudo apt-key add - &> /dev/null" "$PACKAGE_READABLE_NAME"
}

apt_add_repo() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! apt_ppa_installed "$PACKAGE"; then
        execute "sudo apt-add-repository -y "$PACKAGE" &> /dev/null" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

apt_add_source() {
    sudo sh -c "printf 'deb $1' >> '/etc/apt/sources.list.d/$2'" "$3"
}

apt_autoremove() {
    # Remove packages that were automatically installed to satisfy
    # dependencies for other packages and are no longer needed.
    execute \
        "sudo apt autoremove -qqy" \
        "APT Autoremove"
}

apt_install() {
    declare -r EXTRA_ARGUMENTS="$3"
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! apt_installed "$PACKAGE"; then
        execute "sudo apt install --allow-unauthenticated -qqy $EXTRA_ARGUMENTS $PACKAGE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

apt_update() {
    execute \
        "sudo apt update -qqy" \
        "APT Update"
}

apt_upgrade() {
    execute "sudo apt upgrade -qqy --fix-missing" \
        "APT Upgrade"
}

apt_installed() {
    dpkg -s "$1" &> /dev/null
}

apt_ppa_installed() {
    grep -q "^deb .*$1" /etc/apt/sources.list /etc/apt/sources.list.d/*  &> /dev/null
}


#==================================
# SNAP
#==================================
snap_install() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! snap_installed "$PACKAGE"; then
        execute "sudo snap install --classic $PACKAGE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

snap_installed() {
    snap list --all | grep -i $1 &> /dev/null
}


#==================================
# CARGO
#==================================
cargo_install() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! snap_installed "$PACKAGE"; then
        execute "cargo install $PACKAGE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

#==================================
# FLATPAK
#==================================
flatpak_install() {
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! flatpak_installed "$PACKAGE"; then
        execute "flatpak install -y flathub $PACKAGE" "$PACKAGE_READABLE_NAME"
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi
}

flatpak_installed() {
    flatpak list --columns=name,application | grep -i $1 &> /dev/null
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


#==================================
# GNOME EXTENSION
#==================================
extension_install()
{
   EXTENSION_ID=$(curl -s --silent $2 | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs --silent "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -qO ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip  &> /dev/null
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
     gnome-extensions enable ${EXTENSION_ID}
     print_result $? "$1"
    rm ${EXTENSION_ID}.zip
}
