# --- Aliases ---
source ~/.config/aliases/.aliases

# --- ZSH Plugins ---
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- fzf ---
source <(fzf --zsh)

# --- Mise ---
eval "$(mise activate zsh)"

# --- Starship :: Keep EOF ---
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
