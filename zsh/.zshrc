# -- Path
export PATH="$HOME/.local/bin:$PATH"

# -- mise
eval "$(~/.local/bin/mise activate zsh)"

# -- Starship (keep at end of file)
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
