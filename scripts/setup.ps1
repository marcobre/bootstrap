function Install-Dotfiles {
    # $env:OS is "Windows_NT" on every Windows edition and display language.
    # (The old `systeminfo | findstr "OS Name"` check failed on localized Windows,
    # e.g. German Windows labels it "Betriebssystemname".)
    if ($env:OS -ne "Windows_NT") {
        Write-Host "This setup only supports Windows."
        return
    }

    # Define
    $repoUrl      = "https://github.com/marcobre/bootstrap/archive/refs/heads/main.zip"
    $dotfilesPath = Join-Path $env:USERPROFILE ".dotfiles"
    $zipFile      = Join-Path $env:TEMP "dotfiles.zip"
    # Staging folder on the same drive as the target, so Move-Item can move the folder
    $extractPath  = Join-Path $env:USERPROFILE ".dotfiles-download"

    # Check if dotfiles folder exists
    if (Test-Path -Path $dotfilesPath) {
        Write-Host ".dotfiles folder already exists."
        return
    }

    try {
        # Download the repository
        Invoke-WebRequest -Uri $repoUrl -OutFile $zipFile -UseBasicParsing -ErrorAction Stop

        # Extract it to a clean staging folder
        if (Test-Path -Path $extractPath) {
            Remove-Item -Path $extractPath -Recurse -Force -ErrorAction Stop
        }
        Expand-Archive -Path $zipFile -DestinationPath $extractPath -Force -ErrorAction Stop

        # GitHub archives contain a single top-level folder named "<repo>-<branch>"
        # (currently "bootstrap-main"). Detect it instead of hardcoding the name.
        $rootFolder = Get-ChildItem -Path $extractPath -Directory | Select-Object -First 1
        if (-not $rootFolder) {
            throw "The downloaded archive does not contain a folder."
        }

        # Move it into place as .dotfiles
        Move-Item -Path $rootFolder.FullName -Destination $dotfilesPath -ErrorAction Stop

        Write-Host "Dotfiles installed successfully."
    }
    catch {
        Write-Host "Error: $_"
    }
    finally {
        # Clean up the ZIP file and staging folder, whether or not the install worked
        Remove-Item -Path $zipFile -Force -ErrorAction SilentlyContinue
        Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Start-Setup {
    # Define the path to the additional script
    $setupScript = Join-Path $env:USERPROFILE '.dotfiles\system\windows\install.ps1'

    # Check if the additional script exists
    if (-not (Test-Path -Path $setupScript)) {
        Write-Host "Error: Additional script not found at $setupScript."
        return
    }

    try {
        # Run the additional script
        . $setupScript

        Write-Host "Setup Completed."
    }
    catch {
        Write-Host "Error: $_"
    }
}

Install-Dotfiles

Start-Setup
