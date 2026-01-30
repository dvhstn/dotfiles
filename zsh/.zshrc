# --- ZSH PLugins ---
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Mise ---
eval "$(mise activate zsh)"

# --- Starship :: Keep EOF ---
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
export PATH="$HOME/.local/bin:$PATH"
