# dotfiles

My personal development environment, managed with [GNU Stow](https://www.gnu.org/software/stow/). Works on **macOS** and **Ubuntu/WSL2**.

## Quick Start

```bash
git clone https://github.com/alperiox/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The install script detects your OS and handles everything — packages, symlinks, plugin managers, and shell setup.

## What's Included

### Stow Packages

Each directory is a stow package that mirrors the home directory structure. Run `stow <package>` to symlink it, `stow -D <package>` to unlink.

| Package | Contents |
|---------|----------|
| `zsh/` | `.zshrc`, `.zshenv`, `.zprofile` — Oh-My-Zsh + Zinit + zsh-vi-mode |
| `bash/` | `.bashrc`, `.bash_profile` |
| `git/` | `.gitconfig`, `.gitignore_global` |
| `tmux/` | `.tmux.conf` — prefix `C-Space`, vim bindings, TPM plugins |
| `nvim/` | NvChad (v2.5) + Lazy.vim, LSP, minuet-ai, csvview, tuxedo |
| `ghostty/` | Config, Rose Pine Moon theme, 18 cursor shaders |
| `starship/` | Custom Starship prompt with Rose Pine colors |
| `p10k/` | Powerlevel10k config (optional, kept as fallback) |
| `bin/` | `tmux-sm` — tmux session manager with pin/idle tagging |
| `secrets/` | `.secrets.zsh.example` — template for API keys (never committed) |

### Brewfile (macOS)

All Homebrew formulas and casks for one-command restore:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

## What the Install Script Does

1. **Packages** — Homebrew + Brewfile on macOS, apt + PPAs on Ubuntu
2. **Stow** — Symlinks all config packages to `$HOME`
3. **Secrets** — Creates `~/.secrets.zsh` from the example template
4. **Oh-My-Zsh** — Installs if missing (keeps existing `.zshrc`)
5. **Zinit** — Zsh plugin manager
6. **TPM** — Tmux Plugin Manager (press `C-Space + I` after first launch)
7. **Starship** — Cross-shell prompt
8. **Rust** — Installs via rustup
9. **NVM** — Node version manager
10. **Nerd Font** — Symbols-only font (Linux only; macOS uses brew cask)
11. **zsh as default** — Sets zsh via `chsh` on Linux

## Post-Install

```bash
# 1. Add your API keys
vim ~/.secrets.zsh

# 2. Install tmux plugins
tmux
# Press: C-Space + I

# 3. Open nvim (plugins auto-install on first launch)
nvim
```

## Key Bindings

### Tmux (prefix: `C-Space`)

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate panes (vim-style) |
| `C-h/j/k/l` | Resize panes |
| `"` / `%` | Split pane (inherits cwd) |
| `N` | New named session |
| `Tab` | Switch to last client |
| `s` | Choose session tree |
| `P` | Pin session (tmux-sm) |
| `X` | Unpin session |
| `M` | Mark session idle |
| `Z` | Unmark idle |
| `A` | List all sessions |

### Neovim (leader: `Space`)

| Key | Action |
|-----|--------|
| `;` | Enter command mode |
| `jk` | Exit insert mode |
| `gd` / `gD` | Go to definition / declaration |
| `gi` / `gr` | Implementation / references |
| `K` | Hover docs |
| `gl` | Diagnostics float |
| `F2` | Rename symbol |
| `F3` | Format |
| `F4` | Code action |
| `<leader>cp` | Copy file path |
| `<leader>td` | Tuxedo todo |
| `Alt-A` | Accept AI completion (minuet) |
| `Alt-a` | Accept line |
| `Alt-]` / `Alt-[` | Next / prev suggestion |

## Theme

[Rose Pine](https://rosepinetheme.com/) everywhere:

- **Neovim** — `rosepine` via NvChad base46
- **Tmux** — `rose-pine/tmux` (main variant)
- **Ghostty** — `rose-pine-moon` custom theme
- **Starship** — Rose Pine base colors (`#191724`, `#EB6F92`, `#F6C177`)

## WSL2 Notes

The install script works on WSL2 (detects as Linux), but:

- **Fonts**: Install Nerd Font on **Windows**, not in WSL — your terminal renders from the Windows side
- **Ghostty**: Not available on WSL2; the stow package is skipped automatically
- **Clipboard**: Install [win32yank](https://github.com/equalsraf/win32yank) for nvim clipboard integration:
  ```bash
  curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
  unzip /tmp/win32yank.zip -d /tmp/win32yank
  mv /tmp/win32yank/win32yank.exe ~/.local/bin/
  ```

## Managing Dotfiles

```bash
cd ~/dotfiles

# Add a new config
mkdir -p newpkg/.config/newtool
cp ~/.config/newtool/config newpkg/.config/newtool/
stow newpkg

# Edit a config (symlinked — changes are already in the repo)
vim ~/.tmux.conf  # edits dotfiles/tmux/.tmux.conf

# Remove a package
stow -D ghostty

# Re-stow after pulling updates
stow -R zsh tmux nvim
```

## Secrets

API keys live in `~/.secrets.zsh` (never committed). The example template is at `secrets/.secrets.zsh.example`. Both `.zshrc` and `.bashrc` source this file if it exists.

## Structure

```
dotfiles/
├── install.sh           # Cross-platform bootstrap
├── Brewfile             # Homebrew packages (macOS)
├── bash/                # Bash configs
├── bin/                 # Custom scripts (~/.local/bin/)
├── ghostty/             # Terminal config + shaders + theme
├── git/                 # Git config + global ignore
├── nvim/                # Neovim (NvChad + plugins)
├── p10k/                # Powerlevel10k (optional)
├── secrets/             # API key template
├── starship/            # Starship prompt
├── tmux/                # Tmux config
└── zsh/                 # Zsh configs
```
