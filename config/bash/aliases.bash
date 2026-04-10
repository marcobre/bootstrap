# Run dotfiles bin
alias dotfiles="bash ~/.dotfiles/bin/dotfiles/main.sh"
alias colors="bash ~/.dotfiles/bin/colors/colors.sh"

# Directory Shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias mark="pwd > ~/.sd"
alias port='cd $(cat ~/.sd)'

alias h="cd ~ && ls -a"
alias d="cd ~/Dokumente && ls -a"
alias D="cd ~/Downloads && ls -a"
alias b="cd ~/Bilder && ls -a"
alias v="cd ~/Videos && ls -a"
alias m="cd ~/Musik && ls -a"
alias s="cd ~/.config/Scripts && ls -a"
alias r="cd / && ls -a"
alias cf="cd ~/.config && ls -a"

# Command replacements
alias fzf='fzf --preview "bat --style numbers,changes --color=always {} | head -500"'
alias exa='command eza --group-directories-first -laho --no-user --icons --git --git-repos --time-style relative'
alias eza='command eza --group-directories-first -laho --no-user --icons --git --git-repos --time-style relative'
alias ll='command eza -lbhHigUmuSa --time-style=long-iso --icons --git --color-scale'
alias la='command eza -laho --time-style=long-iso --icons --git --color-scale'
alias l='command eza --all --icons'
alias ls='command eza -l -a --icons --group-directories-first'
alias cat='bat'
alias man='batman'

#Generic shortcuts:
alias music="ncmpcpp"
alias clock="ncmpcpp -s clock"
alias visualizer="ncmpcpp -s visualizer"
alias news="newsraft"
alias email="mutt"
alias files="ranger"
alias chat="weechat"
alias audio="alsamixer"
alias calender="calcurse"
alias lg=lazygit
alias matrix='cmatrix -aBf'
alias fast='fast -u --single-line'
alias ff="clear && fastfetch"
alias ping='c_prettyping'
alias traceroute='c_mtr'
alias sdn="sudo shutdown now"
alias yt="youtube-dl -ic"
alias yta="youtube-dl -xic"
alias starwars="telnet towel.blinkenlights.nl"

# History
alias h="history -15"    # last 10 history commands
alias hc="history -c"    # clear history
alias hg="history | rg " # +command

# move to Second Brain
alias sb="cd ~/Syncthing/Obsidian/ && ls -a"

# Neovim config aliases
alias nv="nvim-lazy"
alias sv="sudo nvim-lazy"
alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias nvim-lazy="NVIM_APPNAME=nvim-lazyvim nvim"
alias nvim-marcom="NVIM_APPNAME=nvim-marcom nvim"
alias nvim-fisavim="NVIM_APPNAME=nvim-fisavim nvim"

# Webcam aliases
alias dellcam="mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:/dev/video4 --profile=low-latency --untimed --vf=hflip"
alias cam="mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:/dev/video0 --profile=low-latency --untimed --vf=hflip"

# set variable and alias for calcurse pass usage
#CALCURSE_CALDAV_PASSWORD=$(pass show area030.org)
#alias calsync="CALCURSE_CALDAV_PASSWORD=$(pass show area030.org) calcurse-caldav"

# SSH Public Keys
alias sshpubkey="pbcopy < ~/.ssh/id_ed25519.pub | echo 'SSH Public Key copied to pasteboard.'"

# IP addresses
alias pubip="dig +short txt ch whoami.cloudflare @1.0.0.1"
alias locip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Update Neovim NVChad
alias nupdate="nvim -c \"NvChadUpdate\""

# Update LunarVim
alias lvupdate="lvim +LvimUpdate +q"

# Screenshare portal
#alias screenshare="~/.config/hypr/scripts/PortalHyprland.sh"
