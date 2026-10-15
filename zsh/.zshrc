# -- Path
typeset -U path fpath
export PATH="$HOME/.local/bin:$PATH"

# -- mise
eval "$(~/.local/bin/mise activate zsh)"

# -- Plugins
source ~/.dotfiles/zsh/.zsh-plugins

# -- Starship (keep at end of file)
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
