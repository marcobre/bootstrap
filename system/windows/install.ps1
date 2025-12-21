# Source Windows Utilities
. "$env:USERPROFILE\.dotfiles\scripts\utils\utils_windows.ps1"

#==================================
# Check for Interactive Mode
#==================================
function Test-InteractiveMode {
    # Check if we're in an interactive environment
    # Be more permissive - only exclude clearly non-interactive cases
    if ($env:CI -or $env:AUTOMATION -or ([Environment]::GetCommandLineArgs() -contains '-NonInteractive')) {
        return $false
    } else {
        return $true
    }
}

function Get-InstallationMode {
    Clear-Host
    
    # Beautiful header with Windows styling
    Write-Host ""
    Write-Host "╭─────────────────────────────────────────────────────────╮" -ForegroundColor Magenta
    Write-Host "│               Windows Dotfiles Setup                   │" -ForegroundColor Magenta  
    Write-Host "│               Choose Installation Mode                  │" -ForegroundColor Magenta
    Write-Host "╰─────────────────────────────────────────────────────────╯" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Select your preferred installation method" -ForegroundColor Gray
    Write-Host ""
    
    # Beautiful menu options with PowerShell styling
    Write-Host "Installation modes:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  → " -NoNewline -ForegroundColor Cyan
    Write-Host "1) Interactive Installation (Recommended - PowerShell menus, WSL2)" -ForegroundColor White
    Write-Host "  → " -NoNewline -ForegroundColor Cyan
    Write-Host "2) Complete Automatic Installation (Install everything)" -ForegroundColor White
    Write-Host "  → " -NoNewline -ForegroundColor Cyan
    Write-Host "3) Traditional Mode (Original behavior)" -ForegroundColor White
    Write-Host ""
    
    do {
        Write-Host "Which installation mode would you prefer? " -NoNewline -ForegroundColor Green
        $choice = Read-Host "(1/2/3)"
        switch ($choice) {
            "1" { return "interactive" }
            "2" { return "automatic" }
            "3" { return "traditional" }
            default { 
                Write-Host "Invalid choice. Please select 1, 2, or 3." -ForegroundColor Red
                Write-Host ""
            }
        }
    } while ($true)
}

function Start-InteractiveInstallation {
    if (Test-Path "$env:USERPROFILE\.dotfiles\system\windows\install_interactive.ps1") {
        . "$env:USERPROFILE\.dotfiles\system\windows\install_interactive.ps1"
    } else {
        Write-Host "Interactive installation script not found!" -ForegroundColor Red
        Write-Host "Falling back to traditional installation..." -ForegroundColor Yellow
        Start-TraditionalInstallation
    }
}

function Start-AutomaticInstallation {
    Write-Section "Running Complete Windows Installation"
    Write-Host "This will install ALL available packages, tools, and configurations." -ForegroundColor Yellow
    
    $confirm = Read-Host "Continue with complete installation? (y/N)"
    if ($confirm -eq 'y' -or $confirm -eq 'Y') {
        Start-TraditionalInstallation
        Write-Host "Complete installation finished!" -ForegroundColor Green
    } else {
        Write-Host "Installation cancelled by user" -ForegroundColor Yellow
        exit 0
    }
}

function Start-TraditionalInstallation {
    Write-Section "Running Windows Dotfiles Setup"

    # Setup Variables
    Invoke-Script ".dotfiles\system\windows\setup_variables.ps1"

    # Setup Config
    Invoke-Script ".dotfiles\system\windows\setup_config.ps1"

    # Setup Packages
    Invoke-Script ".dotfiles\system\windows\setup_packages.ps1"

    # Setup Fonts
    Invoke-Script ".dotfiles\system\windows\setup_fonts.ps1"

    # Setup Shell
    Invoke-Script ".dotfiles\system\windows\setup_shell.ps1"

    # Generate Git Credentials
    Invoke-Script ".dotfiles\system\windows\setup_git_creds.ps1"

    # Setup WSL2
    Invoke-Script ".dotfiles\system\windows\setup_wsl.ps1"

    # Setup Complete
    Write-Host -ForegroundColor Green "Marcom Dotfiles Successfully Installed"
}

#==================================
# Main Installation Logic
#==================================

# Check if we should run in interactive mode
if (Test-InteractiveMode -and $args -notcontains "--no-interactive") {
    $mode = Get-InstallationMode
    
    switch ($mode) {
        "interactive" {
            Start-InteractiveInstallation
        }
        "automatic" {
            Start-AutomaticInstallation
        }
        "traditional" {
            Start-TraditionalInstallation
        }
        default {
            Start-TraditionalInstallation
        }
    }
} else {
    # Run traditional installation if no interactive mode or explicitly disabled
    Start-TraditionalInstallation
}
