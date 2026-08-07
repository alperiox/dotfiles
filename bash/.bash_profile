set -o vi # added by BEN
source "$HOME/.docker/init-bash.sh" || true # Added by Docker Desktop
[ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
