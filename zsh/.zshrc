# PATH
export PATH="$HOME/.local/bin:$PATH"

# COMPLETION
source "$HOME/.dotfiles/zsh/completion.zsh"

# PLUGINS
source "$HOME/.dotfiles/zsh/plugins.zsh"

# STARSHIP
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"
