#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# ── Colors ─────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[dotfiles]${NC} $*"; }
warn()  { echo -e "${YELLOW}[dotfiles]${NC} $*"; }
error() { echo -e "${RED}[dotfiles]${NC} $*"; }

# ── Detect OS ──────────────────────────────────────────────────────────────────
OS="unknown"
case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)  OS="linux" ;;
esac

info "Detected OS: $OS"

if [[ "$OS" == "unknown" ]]; then
    error "Unsupported operating system."
    exit 1
fi

# ── 1. Install packages ───────────────────────────────────────────────────────

install_macos() {
    # Install Homebrew
    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        info "Homebrew already installed."
    fi

    # Install packages from Brewfile
    info "Installing Homebrew packages..."
    brew bundle --file="$DOTFILES_DIR/Brewfile" || warn "Some brew packages may have failed. Check output above."
}

install_linux() {
    info "Updating apt and installing packages..."
    sudo apt-get update

    # Core tools available via apt
    sudo apt-get install -y \
        zsh \
        git \
        curl \
        wget \
        stow \
        tmux \
        ripgrep \
        fd-find \
        fzf \
        jq \
        tree \
        build-essential \
        cmake \
        python3 \
        python3-pip \
        python3-venv \
        pipx \
        ffmpeg \
        imagemagick \
        pandoc \
        nmap \
        redis-server \
        xz-utils \
        unzip \
        fontconfig

    # fd-find installs as fdfind on Ubuntu — create symlink
    if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        info "Created fd symlink for fd-find."
    fi

    # Neovim (latest via PPA)
    if ! command -v nvim &>/dev/null; then
        info "Installing Neovim from PPA..."
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update
        sudo apt-get install -y neovim
    else
        info "Neovim already installed."
    fi

    # GitHub CLI
    if ! command -v gh &>/dev/null; then
        info "Installing GitHub CLI..."
        (type -p wget >/dev/null || sudo apt-get install wget -y) \
            && sudo mkdir -p -m 755 /etc/apt/keyrings \
            && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
            && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
            && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
            && sudo apt-get update \
            && sudo apt-get install gh -y
    else
        info "GitHub CLI already installed."
    fi

    # git-lfs
    if ! command -v git-lfs &>/dev/null; then
        sudo apt-get install -y git-lfs
    fi
    git lfs install

    # zsh-vi-mode (manual clone on Linux)
    if [ ! -d "$HOME/.zsh-vi-mode" ]; then
        info "Installing zsh-vi-mode..."
        git clone https://github.com/jeffreytse/zsh-vi-mode.git "$HOME/.zsh-vi-mode"
    else
        info "zsh-vi-mode already installed."
    fi

    # zoxide (installer script)
    if ! command -v zoxide &>/dev/null; then
        info "Installing zoxide..."
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    else
        info "zoxide already installed."
    fi

    # Set zsh as default shell
    if [[ "$SHELL" != *"zsh"* ]]; then
        info "Setting zsh as default shell..."
        chsh -s "$(command -v zsh)"
    fi
}

if [[ "$OS" == "macos" ]]; then
    install_macos
else
    install_linux
fi

# ── 2. Stow all packages ──────────────────────────────────────────────────────
STOW_PACKAGES=(zsh bash git tmux nvim starship p10k bin)

# Ghostty is available on both, but shaders/themes may only matter on desktop
if [[ "$OS" == "macos" ]] || command -v ghostty &>/dev/null; then
    STOW_PACKAGES+=(ghostty)
fi

info "Stowing dotfiles..."
for pkg in "${STOW_PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        info "  Stowing $pkg..."
        stow -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg" 2>&1 | while read -r line; do
            echo "    $line"
        done
    else
        warn "  Package '$pkg' not found, skipping."
    fi
done

# ── 3. Set up secrets file ────────────────────────────────────────────────────
if [ ! -f "$HOME/.secrets.zsh" ]; then
    info "Creating ~/.secrets.zsh from example..."
    cp "$DOTFILES_DIR/secrets/.secrets.zsh.example" "$HOME/.secrets.zsh"
    chmod 600 "$HOME/.secrets.zsh"
    warn "Edit ~/.secrets.zsh to add your API keys."
else
    info "~/.secrets.zsh already exists, skipping."
fi

# ── 4. Install Oh My Zsh ──────────────────────────────────────────────────────
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    info "Oh My Zsh already installed."
fi

# ── 5. Install Zinit ──────────────────────────────────────────────────────────
if [ ! -d "$HOME/.local/share/zinit/zinit.git" ]; then
    info "Installing Zinit..."
    mkdir -p "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
else
    info "Zinit already installed."
fi

# ── 6. Install TPM (Tmux Plugin Manager) ──────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    info "Start tmux and press prefix+I to install tmux plugins."
else
    info "TPM already installed."
fi

# ── 7. Install Starship prompt ─────────────────────────────────────────────────
if ! command -v starship &>/dev/null; then
    info "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    info "Starship already installed."
fi

# ── 8. Install Rust (for cargo) ───────────────────────────────────────────────
if ! command -v rustup &>/dev/null; then
    info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    info "Rust already installed."
fi

# ── 9. Install NVM ────────────────────────────────────────────────────────────
if [ ! -d "$HOME/.nvm" ]; then
    info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
else
    info "NVM already installed."
fi

# ── 10. Make tmux-sm executable ────────────────────────────────────────────────
if [ -f "$HOME/.local/bin/tmux-sm" ]; then
    chmod +x "$HOME/.local/bin/tmux-sm"
    info "tmux-sm is ready."
fi

# ── 11. Set up git ────────────────────────────────────────────────────────────
if [ -f "$HOME/.gitignore_global" ]; then
    git config --global core.excludesfile "$HOME/.gitignore_global"
    info "Global gitignore configured."
fi

# ── 12. Install Nerd Font (Linux only — macOS uses brew cask) ─────────────────
if [[ "$OS" == "linux" ]]; then
    FONT_DIR="$HOME/.local/share/fonts"
    if [ ! -f "$FONT_DIR/SymbolsNerdFontMono-Regular.ttf" ]; then
        info "Installing Symbols Nerd Font..."
        mkdir -p "$FONT_DIR"
        TMPDIR=$(mktemp -d)
        curl -fsSL -o "$TMPDIR/NerdFontsSymbolsOnly.tar.xz" \
            "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz"
        tar -xf "$TMPDIR/NerdFontsSymbolsOnly.tar.xz" -C "$FONT_DIR"
        fc-cache -f "$FONT_DIR"
        rm -rf "$TMPDIR"
        info "Nerd Font symbols installed."
    else
        info "Nerd Font symbols already installed."
    fi
fi

# ── Done ───────────────────────────────────────────────────────────────────────
echo ""
info "========================================="
info "  Dotfiles installation complete! ($OS)"
info "========================================="
echo ""
warn "Next steps:"
warn "  1. Edit ~/.secrets.zsh with your API keys"
warn "  2. Open tmux and press C-Space + I to install plugins"
warn "  3. Open nvim — Lazy.nvim will auto-install plugins on first launch"
if [[ "$OS" == "linux" ]]; then
    warn "  4. Log out and back in for zsh to take effect as default shell"
else
    warn "  4. Restart your terminal or run: source ~/.zshrc"
fi
echo ""
