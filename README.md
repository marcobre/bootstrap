<p align="center">
 <h1 align="center">Excalith Dotfiles Clone</h1>
</p>

![Screenshot of alacritty terminal using fish shell with spaceship prompt and tmux, displaying neofetch, nvim and custom scripts](assets/screenshots/dotfiles.png)

## Features

- Fully customizable installation depending on OS
- The [installer](scripts/) is seperated from configs and install scripts
- A [dotfiles manager](bin/dotfiles/main.sh) for post-install maintenance
- Has post-install scripts for configuring `git`, `ssh` and `gpg`
- Requires git commands for syncing without fancy dotfile managers

## Uses

- Supports `bash`, `zsh`, `fish`, `cmd` and `powershell` with `starship` shell prompt and has `tmux` support except for `cmd` and `powershell`
- Replaces default terminal with `Alacritty`

## Installation

> [!CAUTION]
> If you have no idea what a dotfile is all about, please do not simply run these commands. They will override your configurations with my configurations and install bunch of packages.

Depending on your OS, copy and paste the code to start installation. This code will download my dotfiles and start setup depending on your OS.

### MacOS 12.0 Monterey (and above) WIP

```bash
bash -c "$(curl -LsS https://raw.github.com/marcobre/bootstrap/main/scripts/setup.sh)"
```

### Ubuntu 22.04 Jammy Jellyfish (and above)

```bash
bash -c "$(wget --no-cache -qO - https://raw.github.com/marcobre/bootstrap/main/scripts/setup.sh)"
```

### Arch Linux WIP

```bash
bash -c "$(wget --no-cache -qO - https://raw.github.com/marcobre/bootstrap/main/scripts/setup.sh)"
```

### Lite Version WIP

This is a minimal installation for Termux app on Android.

```bash
bash -c "$(curl -LsS https://raw.github.com/marcobre/bootstrap/main/system/lite/install.sh)"
```

### Windows (10 and above) WIP

#### Windows

Allow remote scripts to run

```ps
# Allows you to run the script from remote
Set-ExecutionPolicy Bypass -Scope Process

# Allows you to run scripts locally
Set-ExecutionPolicy RemoteSigned -Force
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
```

Download the dotfiles and start setup

```ps
Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/excalith/.dotfiles/main/scripts/setup.ps1').Content
```

Reset Execution Policy

```ps
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Restricted
```

#### WSL Ubuntu

To install packages for WSL Ubuntu, run the following command on WSL terminal.

```bash
bash -c "$(wget --no-cache -qO - https://raw.github.com/excalith/.dotfiles/main/scripts/setup.sh)"
```

## Post-Installation

Optionally, if you want to set upstream with this repository, you can run the following command.

```bash
# Initialize git repository
git init

# Add this repository as remote
git remote add origin git@github.com:excalith/.dotfiles.git

# Fetch the main branch
git fetch origin main

# Reset the dotfiles folder and replace with main branch
git reset --hard origin/main
```

## Using Dotfiles

After installing the dotfiles, you can pretty much start using these configurations right away.

- All changes to configuration files will be recognized by git as modified within dotfiles folder except for the config files created with `.local` suffix.
- You can use `dotfiles` command for dotfile manager script for running maintenance commands.

## Making Your Own Dotfiles

If you want to create your own dotfiles based on my configuration, you should

1. Fork or download this repository
2. Update [setup](scripts/setup.sh) script with your repository settings (do not change the preset `.dotfiles` path)
3. Change the configurations and packages as you wish
4. Push your changes to **your own** repository
5. Run setup bash commands

## Credits

This dotfiles repository is a modified copy of the great [Excalith dotfiles](https://github.com/excalith/.dotfiles) which is heavily ~~knocked-off~~ inspired version of beautiful [Cătălin’s dotfiles](https://github.com/alrra/dotfiles). You should probably check it out!

I have modified this dotfiles with my own taste of config files and updated the Ubuntu related scripts and tested them on the current Ubuntu 24.04 LTS version.
The other OS specific scripts will be modified in the new future and have not tested them yet.
Big Thanks to Excalith for providing me with a solid framework supporting tofile management for the Operating Systems i am actively using.

## License

The code is available under the [MIT license](LICENSE).
