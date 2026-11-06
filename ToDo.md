# ToDo — Known Bugs & Tech Debt

Bugs found while reading the code (not yet reproduced on real machines).
Work through them one at a time; tick the box and note the commit when done.

Priority: **P1** = breaks a fresh install on an actively used OS (macOS, Ubuntu, Arch/CachyOS) ·
**P2** = wrong or partial result · **P3** = cosmetic / WIP platforms.

---

## P1 — Breaks fresh installs

- [x] **macOS (Apple Silicon): gum install fails right after installing Homebrew.**
  *Fixed: new `install_homebrew` in `utils_macos.sh` (NONINTERACTIVE install + `shellenv bash` + `hash -r`), used by `setup.sh`.*
  `scripts/setup.sh` → `install_gum_if_needed` installs brew but never runs
  `eval "$(/opt/homebrew/bin/brew shellenv)"`. `ensure_brew_in_path` lives in
  `utils_macos.sh`, which `setup.sh` doesn't source. Result: interactive mode silently
  falls back to automatic.
- [x] **macOS: `install_homebrew_setup` never calls `ensure_brew_in_path`.**
  `system/macos/install_interactive.sh`. Same root cause as above, in the interactive path.
  *Fixed: it now calls `install_homebrew`, and so does `system/macos/setup_packages.sh`.*
- [x] **macOS: no rc file puts Homebrew on PATH.** There's no `brew shellenv` in
  `config/zsh/.zshrc`, `config/bash/.bashrc` or `config/fish/export.fish`. New shells on
  Apple Silicon can't find brew tools.
  *Fixed: guarded `brew shellenv zsh|bash|fish` line in all three files.*
- [x] **LazyGit download goes to `/dev/null`.**
  *Fixed: new `install_lazygit_release` in `scripts/utils/utils.sh` (arch-aware, SHA-256
  verified, temp dir, no `cd`). Arch uses `pacman`; Ubuntu/WSL use apt when the package
  exists (25.10+), otherwise the release binary; Alpine uses the release binary.* `curl -Lo lazygit.tar.gz --silent --output /dev/null …`.
  The last `--output` wins, so the tarball is never written and the following `tar` fails.
  Affects the automatic installers:
  - `system/ubuntu/setup_packages.sh`
  - `system/arch/setup_packages.sh`
  - `system/alpine/setup_packages.sh`
  - `system/wsl_ubuntu/setup_packages.sh`

  The download is also hardcoded to `x86_64`, so it breaks on arm64.
- [x] **Antigen and Fisher are downloaded from the dead `git.io` shortener.**
  *Correction: git.io still resolves (GitHub kept existing links, but the service is
  deprecated). Fixed anyway: new `install_antigen` / `install_fisher` in `scripts/utils/utils.sh`
  use the canonical URLs (antigen release asset, fisher raw `main`), validate the download,
  and report real success/failure. Also fixed on the way: WSL's antigen download went to
  `/dev/null` (double redirect) and macOS/Alpine/WSL called the undefined `print_progress`.*
  - `curl -L git.io/antigen`: macos, ubuntu, arch, wsl `setup_shell.sh`
  - `curl -sL https://git.io/fisher`: ubuntu, arch, alpine, wsl `setup_shell.sh`

  Replace with:
  - `https://raw.githubusercontent.com/zsh-users/antigen/develop/bin/antigen.zsh`
  - `https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish`
- [x] **Ubuntu: fonts need `jq` and `unzip`, which are never installed.**
  *Fixed: `jq` is no longer needed (fonts use GitHub's `releases/latest/download/<Font>.zip`).
  New `install_nerd_font` / `update_font_cache` in `utils.sh`. Ubuntu and Arch font steps
  (automatic and interactive) install their own deps: curl, unzip, fontconfig. `unzip` was
  also added to the ubuntu, arch, alpine and wsl `setup_packages.sh`.*
- [x] **Arch: `chsh` changes root's shell, not the user's.** *Fixed: `"$USER"` added.*
  `system/arch/setup_shell.sh` runs `sudo chsh -s "$(which fish)"` without a username.
  Fix: `sudo chsh -s "$(which fish)" "$USER"`.
- [x] **Windows: a fresh install fails at the folder rename.** `scripts/setup.ps1` renames
  `.dotfiles-main`, but the archive of `bootstrap` extracts to `bootstrap-main`.
  *Fixed: extracts to a staging folder, detects the top-level folder instead of hardcoding it,
  moves it to `.dotfiles`, stops on errors, and always cleans up.*
- [x] **Windows: the OS check fails on non-English Windows.** `systeminfo | findstr "OS Name"`
  matches the English label only (German: "Betriebssystemname"), so setup quit as "not supported".
  *Fixed: checks `$env:OS -eq "Windows_NT"`.*

## P2 — Wrong or partial results

### macOS (found in the first fresh-Mac test run)
- [x] **Homebrew looked like it was installed twice.** `setup.sh` installed it for gum, then
  `setup_packages.sh` (and the interactive "Homebrew Setup") ran the install step again plus
  `brew update`/`upgrade` right after the installer had already updated. An old leftover block at
  the end of `install_interactive.sh` could also run the installer a second way.
  *Fixed: Homebrew is installed once at the start of `setup.sh` (independent of gum); later steps
  call `brew_prepare`, which skips the update right after a fresh install.*

- [x] **`tldr` formula disabled by Homebrew.** *Fixed: `tlrc` (official client, same `tldr` command).*
- [x] **Alacritty cask disabled by Homebrew** (2026-09-01, fails Gatekeeper check).
  *Fixed: cask commented out in `setup_packages.sh` and the interactive "Terminals" menu; Ghostty
  added instead (package list, interactive menu, Dock). Alacritty configs stay for Linux.*
- [ ] **`HOMEBREW_CASK_OPTS="--no-quarantine --no-binaries"` in `.zshrc` / `.bashrc` is dead.**
  Homebrew removed `--no-quarantine`, so the line does nothing anymore. Remove it.

### Shared (`system/symlink.sh`, `scripts/utils/*`)
- [x] **Re-runs nest symlinks inside the repo.** *Fixed: `symlink()` uses `ln -sfn`.* `symlink` uses `ln -sf`, so linking the
  directories `nvim-lazyvim/` and `nvim-marcom/` again creates
  `config/nvim-lazyvim/nvim-lazyvim` (and the same for marcom). Use `ln -sfn` in
  `utils.sh` → `symlink()`.
- [x] **`symlink()` doesn't quote its paths.** *Fixed together with `ln -sfn`.* It runs `execute "ln -sf $1 $2"`, which
  breaks on paths with spaces.
- [ ] **`symlink.sh` links a fish function that doesn't exist:** `config/fish/functions/gi.fish`.
  Remove the line or add the file.
- [ ] **`symlink.sh` links an alacritty file that doesn't exist:** `alacritty/alacrittyMacos.toml`.
  Only `alacrittyMacos.yml` and the unlinked `alacritty.toml` exist.
- [ ] **Arch gets no alacritty config and no kitty keymap.** `symlink.sh` only handles
  `macos` and `ubuntu`.
- [ ] **Global git ignore file name mismatch.** `config/git/config` sets
  `excludesFile = ~/.config/git/.gitignore.global`, but the scripts link different names:
  - `symlink.sh` → `.gitignore_global`
  - WSL → `ignore_global`
- [ ] **`.bashrc` and `export.fish` put a literal `~` in PATH.** They use quoted
  `"~/.local/bin"` and `"~/.cargo/bin"`, so the tilde isn't expanded. Use `$HOME`.
- [ ] **`generate_gpg.sh` is broken in several places:**
  - writes git signing config to `~/.config/git/config.local`, which isn't included (should be `.gitconfig.local`)
  - the `signingkey` line is appended without a `[user]` header
  - writes `GPG_TTY` to `~/.config/bash/.bash.local` and `~/.config/fish/fish.local`, which are never sourced (should be `~/.bash.local` and `~/.config/fish/local.fish`)
  - uses an undefined `$uname` in the key UID
  - uses GNU-only `cut --delimiter`, which fails on macOS
- [ ] **`generate_ssh.sh` and `generate_gpg.sh` misread their arguments.** `[ ! "$@" ]`
  breaks with more than one argument.
- [ ] **`generate_ssh.sh` duplicates SSH config.** It appends a `Host *` block to
  `~/.ssh/config` on every run.
- [ ] **`init_dotfile_repo.sh` resolves its path wrong and exits.** It runs `cd ../../`
  relative to the cwd, and `exit 1` would kill the parent setup if it were sourced.
- [ ] **Two utils helpers check the wrong thing:**
  - `utils_macos.sh` → `yarn_install` checks the misspelled `$FORPACKAGEMULA`
  - `utils_ubuntu.sh` → `cargo_install` checks `snap_installed` instead of cargo
- [ ] **`utils_ubuntu.sh` → `apt_add_key` uses the deprecated `apt-key`.** It's used for the
  Mono key in `system/ubuntu/setup_packages.sh`. Move it to a keyring under `/etc/apt/keyrings`.
- [ ] **`setup.sh` local runs still download `utils.sh` from GitHub.** The `-x utils.sh`
  check looks in `scripts/`, but the file is in `scripts/utils/`.

### Ubuntu / Arch
- [x] **Interactive installers still have their own LazyGit download.**
  `system/{ubuntu,arch,alpine}/install_interactive.sh` hardcode `x86_64` and skip checksum
  verification.
  *Fixed: same logic as `setup_packages.sh` (`pacman_install` on Arch, apt-or-
  `install_lazygit_release` on Ubuntu, `install_lazygit_release` on Alpine).*
- [ ] **Reversal icons step (ubuntu and arch `setup_packages.sh`, arch interactive):**
  - `cd ~/reversal-icons && . install.sh -a` sources a third-party script into the shared
    shell, and leaves the cwd inside a directory that is then deleted. Run it with
    `bash install.sh -a` in a subshell instead.
  - The cleanup deletes `~/master.tar.gz`, but the file was downloaded as `~/reversal.tar.gz`
    (automatic scripts).
- [x] **Ubuntu: kitty links into `~/.local/bin` without creating it.** *Fixed: `mkdir -p` +
  `ln -sfn` to an explicit target (also safe on re-runs now).*
  `system/ubuntu/setup_packages.sh` needs `mkdir -p ~/.local/bin ~/.local/share/applications`
  first. `~/.local/bin` is also not on PATH during the run.
- [ ] **Ubuntu: TPM `git clone` fails on re-run.** It needs `rm -rf ~/.tmux/plugins/tpm`
  first, like arch does. Same in `system/macos/setup_packages.sh` and WSL.
- [x] **Arch: dead duplicate script in `system/arch/setup_fonts.sh`.** A second, commented
  script is appended after the real one. *Removed with the font rewrite.*
- [ ] **Arch "Change Default Shell" block, remaining issues** (`system/arch/setup_shell.sh`):
  - `print_result $?` reports the exit code of the last `sed`, not of `chsh`, so a failed
    shell change still shows ✔
  - `which fish | sudo tee -a /etc/shells` appends a duplicate line on every run
  - the `pam_shells.so` sed edits aren't needed: root can `chsh` any user
- [ ] **Arch interactive "GNOME Extensions" menu needs `jq`.** `extension_install` uses `jq`, but
  the menu can run before anything installs it. Add `pacman_install "jq" "jq"` at the start of
  `install_gnome_extensions`. (Ubuntu has the same helper; all its calls are commented out.)
- [x] **`system/ubuntu/setup_fonts_old.sh` is unused** (pinned to Nerd Fonts 2.1.0). *Deleted.*
- [ ] **Windows `setup_fonts.ps1` still looks up the version through the GitHub API.** It could use
  `releases/latest/download/<Font>.zip` like the Linux scripts.
- [ ] **Arch interactive menu mislabel:** "AUR Packages" opens the Flatpak menu.
- [ ] **Arch automatic mode skips `setup_defaults.sh`.** It's commented out in
  `system/arch/install.sh`, while interactive "Essential Setup" still runs it. Decide which
  behavior you want.
- [ ] **Arch Mango WM: waybar files aren't linked.** `config/mango/config.jsonc` and
  `style.css` aren't linked by `system/arch/setup_wm.sh`.
- [ ] **`get_os` doesn't recognize Manjaro or EndeavourOS** (if they should be supported).

### macOS
- [x] **`system/macos/setup_shell.sh` calls the undefined `print_progress`.**
  *Fixed with the Antigen change (also Alpine and WSL).*
- [x] **`system/macos/setup_packages.sh` misuses `brew`:**
  - ~~uses raw `brew tap` / `brew install` for emacs-plus and aerospace instead of the wrappers~~
  - ~~`brew install "emacs-plus" "emacs-plus"` installs the same formula twice~~
  - ~~taps `homebrew/core`, `homebrew/cask*` and `homebrew/cask-fonts`, which are deprecated
    or removed and cause errors or noise~~

  *Fixed: official taps dropped; bat-extras now from core; third-party taps are trusted
  and tapped from one list (`BREW_TRUSTED_TAPS` + `brew_setup_taps` in `utils_macos.sh`),
  and items use fully qualified names.*
- [x] **`brew_install "Obsidian" "Obsidian"` is not a formula** in `system/macos/setup_packages.sh`.
  *Fixed: `brew_install "Obsidian" "obsidian" "--cask"`.*
- [x] **`system/macos/install_interactive.sh` → `install_homebrew_setup` still taps the deprecated
  official taps** and uses `brew_tap` + short names for third-party taps.
  *Fixed: uses `brew_setup_taps`; speedtest/aerospace fully qualified; yabai/skhd moved to
  `asmvik/formulae` (koekeishiya renamed); the Emacs menu trusts its tap itself.*
- [ ] **`brew_install` doesn't detect installed casks reliably.** It runs `brew list "$FORMULA"`
  without `--cask`, and casks from untrusted taps can't be loaded at all. Re-runs then
  re-attempt the install (harmless: brew reports "already installed").
- [x] **Two tap names disagree:** `nikitabobko/aerospace` (packages) vs.
  `nikitabobko/tap/aerospace` (interactive). The correct tap is `nikitabobko/tap`.
  *Fixed in `setup_packages.sh` (`nikitabobko/tap/aerospace` cask).*

### Interactive installers (all OSes)
- [ ] **`ask_installation_mode` banners are never shown.** It's called inside `$(...)`, so
  the `gum style` output is captured. Send the UI to `>&2` and drop the
  `tr -d … | xargs` cleanup.
- [ ] **"Exit" kills the whole setup.** It calls `exit 0` in a sourced script, so the git
  creds and restart steps are skipped. Use `return`.
- [ ] **"Custom Selection" is a no-op placeholder.**

### `bin/dotfiles/main.sh` (`dotfiles` command)
- [ ] **Sync → Pull runs `git pop`,** which doesn't exist (should be `git stash pop`).
- [ ] **Sync actions run git in the cwd instead of `~/.dotfiles`.**
- [ ] **The upstream placeholder points to `marcobre/.dotfiles`** (should be `marcobre/bootstrap`).
- [ ] **"CD Into Directory" can't work,** because the script runs in a child bash.
- [ ] **`get_os` only handles macos and ubuntu.**

## P3 — Cosmetic, stale and WIP platforms

### Stale URLs / names
- [ ] **README WSL one-liner and Post-Installation `git remote add` use `marcobre/.dotfiles`.**
- [ ] **`scripts/settings.yml` is unused and still points to excalith.** Remove it or implement it.
- [ ] **`config/fish/lite.config.fish` points to excalith.**
- [ ] **Labels say `pyhton3`:** ubuntu, arch, alpine and wsl `setup_packages.sh`.
- [ ] **`verify_os` minimum Ubuntu is `20.04`,** but the README says 22.04+.

### Alpine
- [x] **`system/alpine/setup_shell.sh` calls `apt_install`,** which is undefined on Alpine,
  so zsh and fish never install. *Fixed: typo, now `apk_install`.*
- [x] **`apk_installed` doesn't check installed status.** *Fixed: `apk info -e`.* `scripts/utils/utils_alpine.sh` uses
  `apk info "$1"`, which also succeeds for packages that are only in the repo index, so
  `apk_install` can skip packages as "already installed". Use `apk info -e "$1"`
  (see `apk-info(8)`).
- [x] **`apk_update` uses an em-dash `—no-progress`** in `scripts/utils/utils_alpine.sh`. *Fixed.*
- [x] **`apk_install` runs without `sudo`,** while update and upgrade use it. *Fixed.*
- [ ] **The text-menu fallback in `ask_installation_mode` is invisible,** because its output is captured.
- [ ] **`mkdir ~/.ssh` is unguarded** in `setup_shell.sh`, and the message has the typo "empy".

### WSL Ubuntu
- [ ] **`system/wsl_ubuntu/symlink.sh` is a stale fork of `system/symlink.sh`:**
  - the `fastfatch` path typo creates a dangling link
  - links the missing `gi.fish`
  - the alacritty branch is dead, since `os_name` is `wsl_ubuntu`
  - touches `config.local` instead of `.gitconfig.local`

  Consider merging it into the shared `symlink.sh`.
- [ ] **WSL `setup_shell.sh` changes root's shell** with `sudo chsh -s /usr/bin/zsh`.
- [ ] **The `delta` apt package may need to be `git-delta`** on some Ubuntu versions.

### Lite (Termux)
- [ ] **All config URLs in `system/lite/install.sh` point to `excalith/.dotfiles`.**
- [ ] **`termux.properties` is written to a nonexistent path:**
  `$HOME/.config/termux/termux.properties/termux.properties`.
- [ ] **prettyping is downloaded to the cwd** and never put on PATH.
- [ ] **The title says "Excalith Dotfiles Setup".**

### Windows
- [ ] **`system/windows/install.ps1` has an operator precedence bug.**
  `if (Test-InteractiveMode -and …)` needs to be `if ((Test-InteractiveMode) -and (…))`.
- [ ] **`scripts/utils/utils_windows.ps1` shadows built-in cmdlets:** `Write-Warning` and `Write-Error`.
- [ ] **`system/windows/setup_wsl.ps1` calls the undefined `Write-Warn`.**
- [ ] **`system/windows/setup_shell.ps1` has two bugs:**
  - the Clink AutoRun check compares the PSObject instead of `.AutoRun`
  - `New-Item "\Documents\…"` creates the folder at the drive root
- [ ] **`system/windows/install_interactive.ps1` has stub menus:**
  - menus 3 and 4 do nothing
  - font options 1 and 2 do nothing
  - menu 2 says "Chocolatey/Scoop" but only runs winget
- [ ] **`bin/dotfiles/main.ps1` is orphaned and broken:**
  - nothing wires it to a command
  - the header and placeholders still say excalith
  - uses the undefined `$SEL_` variable
- [ ] **`config/windows-terminal/settings.json` isn't deployed** by any script.

### Unlinked configs (decide: wire up or delete)
- [ ] **These configs exist but no script links them:** `config/sketchybar`,
  `config/alacritty/alacritty.toml`, `config/warpdev`, `config/startpage`, `config/sonar`,
  `config/blender`, `config/zsh/arasaka`.
- [ ] **`is_remote_execution()` in `scripts/setup.sh` is unused.**
- [ ] **`aur_install` (aura) in `utils_arch.sh` is unused.**
