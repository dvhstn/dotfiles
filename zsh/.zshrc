# --- Homebrew Prefix (Intel vs Apple Silicon) ---
if [ -f /opt/homebrew/bin/brew ]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
fi

# --- ZSH Plugins ---
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# --- Mise ---
eval "$(mise activate zsh --shims)"

# --- Starship :: Keep EOF ---
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"