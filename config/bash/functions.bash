# fzf based menu to load Neovim with different configs
# aliases are defined in aliases.bash
function nvims() {
  items=("default" "nvim-marcom" "nvim-kickstart" "nvim-lazyvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config="nvim-lazyvim"
  fi
  NVIM_APPNAME=$config nvim $@
}

# PKM menue to add a daily note or open existing note from SecondBrain
# If a note name does not exist it will create a new one
# open the note with Neovim alias nv
function memarcom() {
  local pkm_dir="$HOME/Sync/Obsidian"
  local options=("Create Daily Note" "Browse/Create Note")
  local choice=$(printf "%s\n" "${options[@]}" | fzf --prompt=" PKM Action  " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $choice ]]; then
    echo "Nothing selected"
    return 0
  fi

  if [[ $choice == "Create Daily Note" ]]; then
    local daily_note="$pkm_dir/05 - Notes/Daily Notes/$(date +%Y)/$(date +%m)/$(date +%Y-%m-%d).md"
    mkdir -p "$(dirname "$daily_note")"
    [[ ! -f "$daily_note" ]] && cp "$pkm_dir/templates/tp-daily.md" "$daily_note"
    nv "$daily_note"
  else
    local selected=$(find "$pkm_dir" -type f -name "*.md" -not -path '*/.*' | sed "s|$pkm_dir/||" | sed 's/\.md$//' | fzf --prompt=" PKM Note  " --height=~50% --layout=reverse --border --print-query | tail -1)

    if [[ -z $selected ]]; then
      echo "Nothing selected"
      return 0
    fi

    local file_path="$pkm_dir/${selected}.md"
    mkdir -p "$(dirname "$file_path")"
    nv "$file_path"
  fi
}

# copy GPG Public Key to clipboard
function gpgpubkey() {
  gpg --armor --export "$@" | pbcopy | echo 'GPG Public Key copied to pasteboard.'
}

# Flush DNS
function flushdns() {
  printf "\nFlushing DNS\n"
  OS=$(uname)
  case $OS in
  Linux)
    sudo systemd-resolve --flush-caches
    ;;
  Darwin)
    dscacheutil -flushcache
    ;;
  esac

  tmux display-message "Flushed DNS"
}

# Fast CD into directories
function fcd() {
  cd $(tree -dfia -L 1 | fzf) || exit
}

# Makes directory and cd's into it
function mkcd() {
  mkdir -p "$@" && cd "$_" || exit
}

# Install VSCode command line command
function code() {
  VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$*"
}

# Custom Pretty Ping
function c_prettyping() {

  if [ $# -eq 0 ]; then
    prettyping --nolegend 1.1.1.1
  else
    prettyping --nolegend "$@"
  fi
}

# Custom Pretty Ping
function c_mtr() {

  if [ $# -eq 0 ]; then
    sudo mtr 1.1.1.1
  else
    sudo mtr "$@"
  fi
}

function pupdate() {
  printf "\nUpdating starfish\n"
  OS=$(uname)
  case $OS in
  Linux)
    curl -sS https://starship.rs/install.sh | sh
    ;;
  Darwin)
    brew upgrade starship
    ;;
  esac

  tmux display-message "Starship Prompt Update Completed"
}

function treload() {
  tmux source-file ~/.config/tmux/tmux.conf
  tmux display-message "TMUX Config Reloaded"
}

function ql() {
  OS=$(uname)
  case $OS in
  Linux)
    printf "Not implemented yet!\n"
    ;;
  Darwin)
    qlmanage -p "$@" >/dev/null 2>/dev/null &
    ;;
  esac
}

function arasaka() {
  echo "\
                                                         ...--...                                                   \n\
                                                   .:oydmmmNNNNmmmdyo:.                                             \n\
                                                :sdNMMNmdhyhhhhyhdmNMMNds:                                          \n\
                                             -omMMNho:../ydmNNmdy/..:ohNMMdo.                                       \n\
                                           .sNMNh+.   .hMMMMMMMMMMh.   .+hNMNs.                                     \n\
                                          +NMNh:      mMMMMMMMMMMMMm      :hNMN+                                    \n\
                                         yMMm/       :MMMMMMMMMMMMMM:       /mMMy                                   \n\
                                        dMMh.        .NMMMMMMMMMMMMN.        .hMMd                                  \n\
                                       hMMh .ohdmmdho-+NMMMMMMMMMMN+-ohdmmdho. hMMh                                 \n\
                                      /MMN-sNMMMMMMMMMh/smNMMMMNms/hMMMMMMMMMNs-NMM/                                \n\
                                      dMMohMMMMMMMMMMMMm  -mMMm-  mMMMMMMMMMMMMhoMMd                                \n\
                                     .MMM:MMMMMMMMMMMMMM/  dMMd  /MMMMMMMMMMMMMM/MMM.                               \n\
                                     -MMM.NMMMMMMMMMMMMM-  dMMd  -MMMMMMMMMMMMMN.MMM-                               \n\
                                     -MMM /NMMMMMMMMMMMh   dMMd   hMMMMMMMMMMMN/ MMM-                               \n\
                                      NMM/ -yNMMMMMMNMMMh: dMMd :hMMMNMMMMMMNy- /MMN                                \n\
                                      sMMd    -/+++: /dMMMhmMMNhMMMd: :+++/-    dMMs                                \n\
                                       NMM+            /dMMMMMMMMd/            +MMN                                 \n\
                                       :MMM+             /dMMMMd/             +MMM:                                 \n\
                                        :NMMs              mMMm              sMMN:                                  \n\
                                         -dMMm/            dMMd            /mMMd-                                   \n\
                                           oNMMd/          dMMd          /dMMNo                                     \n\
                                             omMMNy/.      dMMd      ./yNMMmo                                       \n\
                                               /yNMMNmho+::yhhy::+ohmNMMNy/                                         \n\
                                                  -oymNMMMNNNNNNMMMNmyo-                                            \n\
                                                       -:/+oooo+/:-                                                 \n\
                                                                                                                    \n\
         -+osyyyo.   -yyyyyyyyyyyyys+.    ./osyyys-          .yyyys:       -/osyyyo.   /yyy-   .+yyyyso++syyyy+     \n\
       +dNMMMMMMMmo. :MMMMMMMMMMMMMMMm  /hNMMMMMMMNy-        -MMMMMNd/   +dNMMMMMMMmo. yMMM:.+hNMMMmhdNNMMMMMMMm+   \n\
     .dMMMho/:/hMMMmo:MMMd///////+mMMM-yMMMds/::yNMMNy.-+oooosdsoooo++ .hMMMdo/:/hMMMmoyMMMmNMMMmy::mMMNho/:/hMMMm+ \n\
     yMMM+      :NMMM/MMMh        ohhhsMMMy      -dMMM: ./hNMMMmy:     yMMM+      :NMMMyMMMMMmy:   dMMM:      /MMMm \n\
     mMMM.       NMMM:NMMMms:         sMMM+       yMMM:----.+hNMMMms:  dMMM-       mMMMsNMMMMs-    NMMN        MMMm \n\
     +MMMd:.     NMMM-dMMMMMMms:      -NMMm+.     yMMM:NMMN.  -odMMMMmssMMMd/.     mMMMomMMMMMNdo- sMMMh:.     MMMm \n\
      +mMMMmdddy.NMMM-hhho+dNMMMds:    :dMMMNmddh:yMMM:mMMMmddddmMMMMMMs+mMMMmdddy.mMMMohhh+sdMMMNdohNMMMmddds.MMMm \n\
       .+hmNNNNNomNNN       -+dNNNNho.   /ydmNNNNhsNNN::dNNNNNNNNNNNNNNo .+hmmNNNNodNNN       :smNNNmmdmmNNNNN/NNNd \n\
                                                                                                                    \n\
" | nms -f red -ca
}

if [ "$0" = "bash" ]; then
  export -f nvims
  export -f memarcom
  export -f gpgpubkey
  export -f flushdns
  export -f mkcd
  export -f code
  export -f c_prettyping
  export -f c_mtr
  export -f arasaka
  export -f pupdate
fi

# Add HDD aliases for WSL cd into mounted drives
#if [[ $(grep -i Microsoft /proc/version) ]]; then
#    alias C="cd /mnt/c"
#    alias D="cd /mnt/d"
#fi
