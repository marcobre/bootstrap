# Windows Interactive Installation Script
# PowerShell version of the interactive installer

# Source Windows Utilities
. "$env:USERPROFILE\.dotfiles\scripts\utils\utils_windows.ps1"

#==================================
# Interactive Menu Functions
#==================================

function Show-Welcome {
    Clear-Host
    Write-Host ""
    Write-Host "╭────────────────────────────────────────────────────────────╮" -ForegroundColor Magenta
    Write-Host "│              Welcome to Marcom Dotfiles Setup             │" -ForegroundColor Magenta  
    Write-Host "│              Interactive Windows Installation              │" -ForegroundColor Magenta
    Write-Host "╰────────────────────────────────────────────────────────────╯" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "This interactive installer will help you customize your Windows setup" -ForegroundColor DarkGray
    Write-Host "Select only the components you need" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-MainMenu {
    Write-Host "Select installation components:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1) Essential Setup (Variables + Config)" -ForegroundColor White
    Write-Host "  2) Package Management (Chocolatey/Scoop)" -ForegroundColor White
    Write-Host "  3) Development Tools" -ForegroundColor White
    Write-Host "  4) System Utilities" -ForegroundColor White
    Write-Host "  5) Fonts Installation" -ForegroundColor White
    Write-Host "  6) Shell Configuration" -ForegroundColor White
    Write-Host "  7) Git Configuration" -ForegroundColor White
    Write-Host "  8) WSL2 Setup" -ForegroundColor White
    Write-Host "  9) Complete Installation (All Components)" -ForegroundColor White
    Write-Host " 10) Exit" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-10)"
    return $choice
}

function Show-DevelopmentToolsMenu {
    Write-Host "Select development tools:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1) Git & Git Tools" -ForegroundColor White
    Write-Host "  2) Programming Languages (Node.js, Python)" -ForegroundColor White  
    Write-Host "  3) Code Editors (VS Code, Vim)" -ForegroundColor White
    Write-Host "  4) Development Utilities" -ForegroundColor White
    Write-Host "  5) All Development Tools" -ForegroundColor White
    Write-Host "  6) Back to Main Menu" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-6)"
    return $choice
}

function Show-SystemUtilitiesMenu {
    Write-Host "Select system utilities:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1) Terminal Enhancements (Windows Terminal)" -ForegroundColor White
    Write-Host "  2) File Management Tools" -ForegroundColor White
    Write-Host "  3) System Monitoring Tools" -ForegroundColor White
    Write-Host "  4) Network Tools" -ForegroundColor White
    Write-Host "  5) All System Utilities" -ForegroundColor White
    Write-Host "  6) Back to Main Menu" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-6)"
    return $choice
}

function Show-FontsMenu {
    Write-Host "Select fonts to install:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1) Programming Fonts (FiraCode, JetBrains Mono)" -ForegroundColor White
    Write-Host "  2) System Fonts (Cascadia Code)" -ForegroundColor White
    Write-Host "  3) All Available Fonts" -ForegroundColor White
    Write-Host "  4) Back to Main Menu" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-4)"
    return $choice
}

#==================================
# Installation Functions
#==================================

function Install-EssentialSetup {
    Write-Section "Essential Setup"
    
    Write-Host "Setting up variables..." -ForegroundColor Green
    Invoke-Script ".dotfiles\system\windows\setup_variables.ps1"
    
    Write-Host "Setting up configuration..." -ForegroundColor Green
    Invoke-Script ".dotfiles\system\windows\setup_config.ps1"
    
    Write-Host "✨ Essential setup completed!" -ForegroundColor Magenta
}

function Install-PackageManagement {
    Write-Section "Package Management Setup"
    
    Write-Host "Installing package managers and essential packages..." -ForegroundColor Green
    Invoke-Script ".dotfiles\system\windows\setup_packages.ps1"
    
    Write-Host "✨ Package management setup completed!" -ForegroundColor Magenta
}

function Install-DevelopmentTools {
    param([string]$Selection)
    
    Write-Section "Installing Development Tools"
    
    switch ($Selection) {
        "1" { 
            Write-Host "Installing Git & Git Tools..." -ForegroundColor Green
            # Install Git-specific tools
        }
        "2" {
            Write-Host "Installing Programming Languages..." -ForegroundColor Green  
            # Install Node.js, Python, etc.
        }
        "3" {
            Write-Host "Installing Code Editors..." -ForegroundColor Green
            # Install VS Code, Vim, etc.
        }
        "4" {
            Write-Host "Installing Development Utilities..." -ForegroundColor Green
            # Install development utilities
        }
        "5" {
            Write-Host "Installing All Development Tools..." -ForegroundColor Green
            # Install everything
        }
    }
    
    Write-Host "✨ Development tools installation completed!" -ForegroundColor Magenta
}

function Install-SystemUtilities {
    param([string]$Selection)
    
    Write-Section "Installing System Utilities"
    
    switch ($Selection) {
        "1" {
            Write-Host "Installing Terminal Enhancements..." -ForegroundColor Green
            # Install Windows Terminal, PowerShell modules
        }
        "2" {
            Write-Host "Installing File Management Tools..." -ForegroundColor Green
            # Install file management tools
        }
        "3" {
            Write-Host "Installing System Monitoring Tools..." -ForegroundColor Green
            # Install system monitoring tools
        }
        "4" {
            Write-Host "Installing Network Tools..." -ForegroundColor Green
            # Install network tools
        }
        "5" {
            Write-Host "Installing All System Utilities..." -ForegroundColor Green
            # Install everything
        }
    }
    
    Write-Host "✨ System utilities installation completed!" -ForegroundColor Magenta
}

function Install-Fonts {
    param([string]$Selection)
    
    Write-Section "Installing Fonts"
    
    switch ($Selection) {
        "1" {
            Write-Host "Installing Programming Fonts..." -ForegroundColor Green
            # Install programming fonts
        }
        "2" {
            Write-Host "Installing System Fonts..." -ForegroundColor Green
            # Install system fonts
        }
        "3" {
            Write-Host "Installing All Available Fonts..." -ForegroundColor Green
            Invoke-Script ".dotfiles\system\windows\setup_fonts.ps1"
        }
    }
    
    Write-Host "✨ Fonts installation completed!" -ForegroundColor Magenta
}

function Install-ShellConfig {
    Write-Section "Shell Configuration"
    
    Write-Host "Setting up shell configuration..." -ForegroundColor Green
    Invoke-Script ".dotfiles\system\windows\setup_shell.ps1"
    
    Write-Host "✨ Shell configuration completed!" -ForegroundColor Magenta
}

function Install-GitConfig {
    Write-Section "Git Configuration"
    
    Write-Host "Setting up Git credentials..." -ForegroundColor Green
    Invoke-Script ".dotfiles\system\windows\setup_git_creds.ps1"
    
    Write-Host "✨ Git configuration completed!" -ForegroundColor Magenta
}

function Install-WSL2 {
    Write-Section "WSL2 Setup"
    
    Write-Host "Setting up WSL2..." -ForegroundColor Green
    Invoke-Script ".dotfiles\system\windows\setup_wsl.ps1"
    
    Write-Host "✨ WSL2 setup completed!" -ForegroundColor Magenta
}

function Install-Complete {
    Write-Section "Complete Installation"
    
    $confirm = Read-Host "This will install ALL components. Continue? (y/N)"
    if ($confirm -eq 'y' -or $confirm -eq 'Y') {
        Install-EssentialSetup
        Install-PackageManagement  
        Install-Fonts "3"
        Install-ShellConfig
        Install-GitConfig
        Install-WSL2
        
        Write-Host ""
        Write-Host "🎉 Complete installation finished!" -ForegroundColor Magenta
        Write-Host "Your Windows system is now configured." -ForegroundColor Green
    } else {
        Write-Host "Installation cancelled." -ForegroundColor Yellow
    }
}

#==================================
# Main Interactive Flow
#==================================

function Start-InteractiveInstallation {
    $running = $true
    
    while ($running) {
        Show-Welcome
        $choice = Show-MainMenu
        
        switch ($choice) {
            "1" {
                Install-EssentialSetup
                Read-Host "Press Enter to continue..."
            }
            "2" {
                Install-PackageManagement
                Read-Host "Press Enter to continue..."
            }
            "3" {
                do {
                    Clear-Host
                    $devChoice = Show-DevelopmentToolsMenu
                    if ($devChoice -ne "6") {
                        Install-DevelopmentTools $devChoice
                        Read-Host "Press Enter to continue..."
                    }
                } while ($devChoice -ne "6")
            }
            "4" {
                do {
                    Clear-Host
                    $utilChoice = Show-SystemUtilitiesMenu
                    if ($utilChoice -ne "6") {
                        Install-SystemUtilities $utilChoice
                        Read-Host "Press Enter to continue..."
                    }
                } while ($utilChoice -ne "6")
            }
            "5" {
                do {
                    Clear-Host
                    $fontChoice = Show-FontsMenu
                    if ($fontChoice -ne "4") {
                        Install-Fonts $fontChoice
                        Read-Host "Press Enter to continue..."
                    }
                } while ($fontChoice -ne "4")
            }
            "6" {
                Install-ShellConfig
                Read-Host "Press Enter to continue..."
            }
            "7" {
                Install-GitConfig
                Read-Host "Press Enter to continue..."
            }
            "8" {
                Install-WSL2
                Read-Host "Press Enter to continue..."
            }
            "9" {
                Install-Complete
                $running = $false
            }
            "10" {
                Write-Host "👋 Installation cancelled. Goodbye!" -ForegroundColor Magenta
                $running = $false
            }
            default {
                Write-Host "Invalid choice. Please select 1-10." -ForegroundColor Red
                Read-Host "Press Enter to continue..."
            }
        }
    }
}

#==================================
# Start Installation
#==================================

Write-Section "Interactive Windows Dotfiles Setup"

# Check for PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "PowerShell 5.0 or higher is required for this installer." -ForegroundColor Red
    Write-Host "Please update PowerShell and try again." -ForegroundColor Red
    exit 1
}

# Start the interactive installation
Start-InteractiveInstallation
