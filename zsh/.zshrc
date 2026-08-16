# ── Secrets (API keys, tokens) ─────────────────────────────────────────────────
[[ -f "$HOME/.secrets.zsh" ]] && source "$HOME/.secrets.zsh"

# ── PATH additions ─────────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/bin"

alias speedtestcf="npx speed-cloudflare-cli"
alias claer=clear
alias grepssh=~/grepssh.sh


# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
if command -v starship &>/dev/null; then
    type starship_zle-keymap-select >/dev/null || \
      {
        eval "$(starship init zsh)"
      }
fi

# zsh-vi-mode: brew on macOS, manual clone on Linux
if command -v brew &>/dev/null; then
    source "$(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
elif [ -f "$HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh" ]; then
    source "$HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh"
fi

# colormap
export TERM=xterm-256color


# rye
[[ -f "$HOME/.rye/env" ]] && source "$HOME/.rye/env"

PROMPT_EOL_MARK=""

export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.local/bin:$PATH"

# Set name of the theme to load
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
plugins=(git)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE="$HOME/.local/bin/micromamba";
export MAMBA_ROOT_PREFIX="$HOME/micromamba";
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
if [[ "$OSTYPE" == darwin* ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
else
    export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
#
# starship
command -v starship &>/dev/null && eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

if [[ -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
    autoload -Uz _zinit
    (( ${+_comps} )) && _comps[zinit]=_zinit

    zinit light-mode for \
        zdharma-continuum/zinit-annex-as-monitor \
        zdharma-continuum/zinit-annex-bin-gem-node \
        zdharma-continuum/zinit-annex-patch-dl \
        zdharma-continuum/zinit-annex-rust
fi

### End of Zinit's installer chunk


if command -v resize >/dev/null 2>&1; then
    eval $(resize)
fi

# Trap SIGWINCH (window resize signal) and run resize
trap 'eval $(resize 2>/dev/null)' WINCH


# zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh --cmd j)"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

clear

# llama.cpp
if [ -d "$HOME/Desktop/coding/llama.cpp/build/bin" ]; then
    export LLAMA_CPP_PATH="$HOME/Desktop/coding/llama.cpp/build/bin"
    export PATH="$LLAMA_CPP_PATH:$PATH"
fi
