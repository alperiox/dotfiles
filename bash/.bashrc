source "$HOME/.docker/init-bash.sh" || true # Added by Docker Desktop
[[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]] && source "$HOME/perl5/perlbrew/etc/bashrc"
alias speedtestcf="npx speed-cloudflare-cli"

export PATH="$HOME/Library/Python/3.11/bin:$PATH"

# ── Secrets (API keys, tokens) ─────────────────────────────────────────────────
[[ -f "$HOME/.secrets.zsh" ]] && source "$HOME/.secrets.zsh"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
