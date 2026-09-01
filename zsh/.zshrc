# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- ZSH Plugins ---
source "$HOME/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# --- Mise ---
eval "$(mise activate zsh --shims)"

# --- Starship :: Keep EOF ---
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"