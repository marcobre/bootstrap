# Cross-Platform Interactive Installation Guide

This guide covers the new interactive installation system for all supported platforms, featuring beautiful `gum`-based menus (where available) for component selection.

## Features

✨ **Interactive Component Selection** - Choose exactly what you want to install
🎨 **Beautiful TUI Menus** - Powered by Charm's `gum` for an elegant experience  
📦 **Modular Installation** - Install components individually or in groups
🔤 **Font Selection Menu** - Pick from 20+ available Nerd Fonts
⚡ **Multiple Installation Modes** - Interactive, Automatic, or Traditional

## Supported Platforms

✅ **Ubuntu/Debian** - Full gum-powered interactive menus  
✅ **macOS** - Homebrew-based interactive installation  
✅ **Arch Linux** - Pacman/AUR/Flatpak interactive menus  
✅ **Alpine Linux** - Simplified text-based menus  
✅ **Windows** - PowerShell-based interactive installation  

## Installation Modes

### 1. Interactive Mode (Recommended)
The new default mode that provides beautiful menus to select components:

**Local Installation:**
```bash
# Clone and run locally (recommended for interactive mode)
git clone https://github.com/marcobre/bootstrap.git ~/.dotfiles
cd ~/.dotfiles
./scripts/setup.sh

# Windows: Run PowerShell script
./scripts/setup.ps1
```

**Remote Installation:**
```bash
# Remote one-liner (will auto re-execute locally for interactive mode)
bash -c "$(wget --no-cache -qO - https://raw.github.com/marcobre/bootstrap/main/scripts/setup.sh)"

# Alternative with curl
bash -c "$(curl -fsSL https://raw.github.com/marcobre/bootstrap/main/scripts/setup.sh)"
```

On all platforms, you'll be presented with installation mode options. Select **Interactive Installation** for the full menu experience.

### 2. Complete Automatic Mode
Installs everything without prompts:

```bash
# Linux/macOS: Choose option 2 when prompted, or force it directly:
cd ~/.dotfiles/system/[platform] && ./install.sh --automatic

# Windows: Choose option 2 when prompted
```

### 3. Traditional Mode
Original behavior - installs all components sequentially:

```bash
# Linux/macOS: Choose option 3 when prompted, or force it:
cd ~/.dotfiles/system/[platform] && ./install.sh --no-interactive

# Windows: Choose option 3 when prompted
```

## Interactive Menu Structure

### Main Menu Options:
- **Essential Setup** - Symlinks and system defaults
- **Package Management Setup** - APT repositories, keys, and package managers
- **Development Tools** - Git, compilers, editors, and development utilities
- **CLI Utilities** - Modern command-line tools (eza, bat, fzf, ripgrep, etc.)
- **GUI Applications** - Desktop applications via APT and Flatpak
- **Fonts Installation** - Selective Nerd Fonts installation
- **Shell Configuration** - Shell setup and configuration
- **Complete Installation** - Install everything at once
- **Custom Selection** - Advanced category-based selection

### Available Components

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
- **ripgrep** - Fast text search
- **fd-find** - Modern find alternative
- **tree & tre-command** - Directory visualization
- **htop** - System monitor
- **httpie** - HTTP client
- **prettyping & mtr** - Network tools
- **tldr** - Quick command help
- **neofetch** - System information
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
Choose from 20+ Nerd Fonts including:
- **CascadiaCode** - Microsoft's programming font
- **FiraCode** - Font with programming ligatures
- **FiraMono** - Mozilla's monospace font
- **JetBrainsMono** - JetBrains' programming font
- **Meslo** - Apple's Menlo adapted
- **SourceCodePro** - Adobe's programming font
- And many more including Hack, Hermit, Noto, RobotoMono, etc.

## Direct Interactive Installation

You can also run the interactive installer directly:

```bash
# Navigate to your dotfiles directory for your platform
cd ~/.dotfiles/system/ubuntu      # Ubuntu/Debian
cd ~/.dotfiles/system/macos       # macOS  
cd ~/.dotfiles/system/arch        # Arch Linux
cd ~/.dotfiles/system/alpine      # Alpine Linux

# Run the interactive installer
./install_interactive.sh
```

**Windows:**
```powershell
# Navigate to Windows directory
cd $env:USERPROFILE\.dotfiles\system\windows

# Run the interactive installer
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
# Force traditional installation
./scripts/setup.sh --no-interactive
```

### Custom Component Installation
Use the "Custom Selection" option in the main menu to:
1. Select specific package categories
2. Review your selections
3. Confirm installation

### Font-Only Installation
```bash
cd ~/.dotfiles/system/ubuntu
# Run interactive installer and select only "Fonts Installation"
./install_interactive.sh
```

## Benefits of Interactive Installation

1. **Faster Setup** - Install only what you need
2. **Reduced Bloat** - Skip unwanted applications
3. **Learning Tool** - See what each component does
4. **Customizable** - Tailor the setup to your workflow
5. **Reversible** - Easy to see what was installed

## Troubleshooting

### Gum Not Available
If `gum` is not installed, the script will:
1. Automatically install it from Charm's repository
2. Fall back to traditional installation if that fails

### Permission Issues
Ensure you have sudo access before running the installation:
```bash
sudo -v
```

### Network Issues
The installer downloads packages and fonts from the internet. Ensure you have a stable connection.

## Platform Requirements

### Linux (Ubuntu/Arch/Alpine)
- **Internet connection** for downloading packages
- **sudo access** for system package installation
- **Terminal with color support** for the best experience

### macOS
- **macOS 12.0+** (Monterey or later)
- **Internet connection** for Homebrew and package downloads
- **Admin privileges** for system-level installations

### Windows
- **Windows 10/11** with PowerShell 5.0+
- **Internet connection** for package managers and downloads
- **Administrator privileges** for system installations
- **Optional:** WSL2 for Linux-like development environment

## What's New

- 🎨 **Cross-Platform Support** - Beautiful menus on all major platforms
- 🖥️ **Platform-Adapted Menus** - macOS (Homebrew), Arch (pacman/AUR), Alpine (apk), Windows (PowerShell)
- 📦 **Granular Component Selection** - Choose exactly what you need on any platform
- 🔤 **Interactive Font Selection** - 20+ Nerd Fonts available across platforms
- ⚡ **Three Installation Modes** - Interactive/Automatic/Traditional on all systems
- 🛡️ **Graceful Platform Detection** - Automatic fallbacks and compatibility checks
- 📋 **Unified Experience** - Same elegant workflow regardless of your OS

The cross-platform interactive installation system makes setting up your development environment enjoyable and personalized on **Ubuntu, macOS, Arch Linux, Alpine Linux, and Windows**!

## Platform-Specific Features

| Platform | Package Managers | Interactive Menus | Font Support | Special Features |
|----------|-----------------|-------------------|--------------|------------------|
| **Ubuntu** | APT, Flatpak, Snap | ✅ Full gum menus | ✅ 20+ Nerd Fonts | GNOME extensions |
| **macOS** | Homebrew, Casks, MAS | ✅ Full gum menus | ✅ Homebrew fonts | Window management |
| **Arch** | pacman, AUR, Flatpak | ✅ Full gum menus | ✅ 20+ Nerd Fonts | GNOME extensions |
| **Alpine** | apk | ✅ Text-based menus | ❌ Minimal setup | Lightweight focus |
| **Windows** | Chocolatey, Scoop | ✅ PowerShell menus | ✅ System fonts | WSL2 integration |
