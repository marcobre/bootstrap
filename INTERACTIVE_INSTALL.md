# Cross-Platform Interactive Installation Guide

This guide covers the interactive installation system for all supported platforms, featuring beautiful `gum`-based menus for component selection.

## Features

✨ **Interactive Component Selection** - Choose exactly what you want to install
🎨 **Beautiful TUI Menus** - Powered by Charm's `gum` for an elegant experience
📦 **Modular Installation** - Install components individually or in groups, in any order
🔤 **Font Selection Menu** - Pick from 19 Nerd Fonts (always the latest release)
🧰 **Self-contained Steps** - Each step installs the tools it needs by itself
⚡ **Two Installation Modes** - Interactive or Complete Automatic

## Supported Platforms

✅ **Ubuntu** - Full gum-powered interactive menus
✅ **macOS** - Homebrew-based interactive installation
✅ **Arch Linux & CachyOS** - Pacman/AUR/Flatpak interactive menus
✅ **Alpine Linux** - gum menus, with simplified text menus as fallback
🚧 **Windows** - PowerShell-based interactive installation (work in progress)
ℹ️ **WSL Ubuntu** - Automatic installation only (no interactive menus)

## Installation Modes

### 1. Interactive Mode (Recommended)

The default mode that provides menus to select components.

**Remote Installation (recommended):**
```bash
# macOS, Arch Linux & CachyOS
bash -c "$(curl -LsS https://raw.githubusercontent.com/marcobre/bootstrap/main/scripts/setup.sh)"

# Ubuntu
bash -c "$(wget --no-cache -qO - https://raw.githubusercontent.com/marcobre/bootstrap/main/scripts/setup.sh)"
```

The one-liner downloads the dotfiles to `~/.dotfiles`, installs `gum`, and then asks for the installation mode. Select **Interactive Installation** for the full menu experience.

**Local Installation:**
```bash
# The clone must live in ~/.dotfiles (all scripts use this path)
git clone https://github.com/marcobre/bootstrap.git ~/.dotfiles
bash ~/.dotfiles/scripts/setup.sh
```

**Windows:**
```ps
Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/marcobre/bootstrap/main/scripts/setup.ps1').Content
```

### 2. Complete Automatic Mode

Installs everything without prompts. Choose **Complete Automatic Installation** when asked, or skip the question entirely:

```bash
# Remote (the "_" is required, it fills $0)
bash -c "$(curl -LsS https://raw.githubusercontent.com/marcobre/bootstrap/main/scripts/setup.sh)" _ --no-interactive

# Local
bash ~/.dotfiles/scripts/setup.sh --no-interactive
```

After the installation (both modes), the setup asks for your git name and e-mail and whether to restart.

## Interactive Menu Structure

### Main Menu Options (Ubuntu)

- **Essential Setup** - Symlinks and system defaults
- **Package Management Setup** - APT repositories, PPAs, keys, nala and Flatpak
- **Window Manager Setup** - Hyprland and Wayland utilities
- **Development Tools** - Git, compilers, editors, and development utilities
- **CLI Utilities** - Modern command-line tools (eza, bat, fzf, zoxide, ripgrep, etc.)
- **GUI Applications** - Desktop applications via APT and Flatpak
- **Fonts Installation** - Selective Nerd Fonts installation
- **Shell Configuration** - zsh, fish, Antigen, Fisher, Starship and tmux plugins
- **Complete Installation** - Install everything at once
- **Custom Selection** - Placeholder, not implemented yet (use the individual menus instead)

The other platforms offer the same idea with their own entries, see [Platform-Specific Features](#platform-specific-features).

### Available Components (Ubuntu)

#### Development Tools
- Git & Git LFS
- Build Essential (compilation tools)
- Python3
- Cargo (Rust toolchain)
- GCC Compiler
- Neovim (modern text editor)
- tmux + TPM (terminal multiplexer)
- LazyGit (Git TUI)

#### CLI Utilities
- **eza** - Modern replacement for `ls`
- **bat** - Cat with syntax highlighting
- **fzf** - Fuzzy finder
- **zoxide** - Smarter `cd` (the shell configs use it as `cd`)
- **ripgrep** - Fast text search
- **fd-find** - Modern find alternative
- **tree & tre-command** - Directory visualization
- **htop** - System monitor
- **httpie** - HTTP client
- **prettyping & mtr** - Network tools
- **tldr** - Quick command help
- **fastfetch** - System information
- **ranger & mc** - File managers
- **fasd** - Quick directory navigation

#### GUI Applications
- **GNOME Tweaks & Extensions** - Desktop customization
- **Alacritty Terminal** - GPU-accelerated terminal
- **Caffeine** - Prevent system sleep
- **Firefox** (Flatpak) - Web browser
- **Spotify** (Flatpak) - Music streaming
- **VLC Media Player** (Flatpak) - Video player
- **Image Optimizer** (Flatpak) - Image compression
- **HEIF Support** - Modern image format support

#### Available Fonts
Choose from 19 Nerd Fonts (or install all of them):
- **CascadiaCode** - Microsoft's programming font
- **FiraCode** - Font with programming ligatures
- **FiraMono** - Mozilla's monospace font
- **JetBrainsMono** - JetBrains' programming font
- **Meslo** - Apple's Menlo adapted
- **SourceCodePro** - Adobe's programming font
- And more: BitstreamVeraSansMono, CodeNewRoman, DroidSansMono, Go-Mono, Hack, Hermit, Noto, Overpass, ProggyClean, RobotoMono, SpaceMono, Ubuntu, UbuntuMono

## Direct Interactive Installation

Once `~/.dotfiles` exists, you can run the interactive installer of your platform directly:

```bash
bash ~/.dotfiles/system/ubuntu/install_interactive.sh   # Ubuntu
bash ~/.dotfiles/system/macos/install_interactive.sh    # macOS
bash ~/.dotfiles/system/arch/install_interactive.sh     # Arch Linux & CachyOS
bash ~/.dotfiles/system/alpine/install_interactive.sh   # Alpine Linux
```

**Windows:**
```powershell
cd $env:USERPROFILE\.dotfiles\system\windows
.\install_interactive.ps1
```

## Menu Navigation

- Use **↑/↓ arrow keys** to navigate
- **Space bar** to select/deselect items (multi-select menus)
- **Enter** to confirm selection
- **Tab** for multi-select confirmation
- **Ctrl+C** to cancel at any time

## Advanced Usage

### Skip Interactive Mode
```bash
# Force automatic installation
bash ~/.dotfiles/scripts/setup.sh --no-interactive
```

The automatic mode is also used when `CI` or `AUTOMATION` is set, or when `TERM=dumb`.

### Custom Component Installation
The "Custom Selection" entry is not implemented yet. To install only some components, run the individual menus one after another; they can be used in any order.

### Font-Only Installation
```bash
bash ~/.dotfiles/system/ubuntu/install_interactive.sh
# select only "Fonts Installation"
```
The font step installs its own dependencies (`curl`, `unzip`, `fontconfig`), so it works without running any other step first.

## Benefits of Interactive Installation

1. **Faster Setup** - Install only what you need
2. **Reduced Bloat** - Skip unwanted applications
3. **Learning Tool** - See what each component does
4. **Customizable** - Tailor the setup to your workflow
5. **Repeatable** - Every step can be run again safely

## Troubleshooting

### Gum Not Available
The setup installs `gum` automatically before the menus start:
- **Ubuntu** from Charm's APT repository
- **macOS** via Homebrew
- **Arch** via pacman
- **Alpine** via apk

If that fails, the setup falls back to the Complete Automatic mode. Alpine offers simplified text menus instead.

### Permission Issues
The setup asks for your sudo password once at the start and keeps it alive during the run. Ensure you have sudo access before starting:
```bash
sudo -v
```
On macOS, casks that ship a `.pkg` installer (for example Karabiner-Elements or GPG Suite) may ask for the password again, because Homebrew resets the sudo session for them.

### Exiting the Menu
**Exit** in the main menu ends the whole setup, so the git credentials and restart steps are skipped. To finish normally, answer "no" to "Return to main menu?" instead.

### Network Issues
The installer downloads packages and fonts from the internet. Ensure you have a stable connection.

## Platform Requirements

### Linux (Ubuntu/Arch/Alpine)
- **Ubuntu 24.04** or newer
- **Arch Linux / CachyOS** (rolling release)
- **Internet connection** for downloading packages
- **sudo access** for system package installation
- **Terminal with color support** for the best experience

### macOS
- **macOS 15 Sequoia** or newer
- **Apple Silicon** (Homebrew's installer no longer supports Intel Macs)
- **Internet connection** for Homebrew and package downloads
- **Admin privileges** for system-level installations

### Windows
- **Windows 10 (version 1809) / 11** with PowerShell 5.0+ and winget
- **Internet connection** for package managers and downloads
- **Administrator privileges** (or Developer Mode) for system installations and symlinks
- **Optional:** WSL2 for a Linux-like development environment

## What's New

- 🍺 **Homebrew installed once** - Set up at the start and on your PATH for the whole run
- 🔐 **Homebrew tap trust** - Third-party taps are trusted automatically (Homebrew 6+)
- 👻 **Ghostty on macOS** - Replaces Alacritty, whose Homebrew cask was disabled
- 📂 **zoxide** - Installed on all platforms and used as `cd` in zsh, bash and fish
- ⚡ **fastfetch** - Replaces neofetch on all platforms
- 🔤 **Fonts without extra dependencies** - Always the latest Nerd Fonts, no `jq` needed
- 🔁 **Safe re-runs** - Symlinks and installers can be run again without side effects

## Platform-Specific Features

| Platform | Package Managers | Interactive Menus | Font Support | Special Features |
|----------|-----------------|-------------------|--------------|------------------|
| **Ubuntu** | APT (incl. PPAs), Flatpak | ✅ Full gum menus | ✅ 19 Nerd Fonts | GNOME, Hyprland |
| **macOS** | Homebrew (formulae, casks, trusted taps) | ✅ Full gum menus | ✅ Homebrew cask fonts | AeroSpace, SketchyBar |
| **Arch / CachyOS** | pacman, yay (AUR), Flatpak | ✅ Full gum menus | ✅ 19 Nerd Fonts | GNOME extensions, MangoWM |
| **Alpine** | apk | ✅ gum menus, text fallback | ❌ Minimal setup | Lightweight focus |
| **Windows** | winget | 🚧 PowerShell menus | ✅ Nerd Fonts | WSL2 integration |
| **WSL Ubuntu** | APT (incl. PPAs) | ❌ Automatic only | ❌ (use Windows fonts) | Runs inside WSL |
