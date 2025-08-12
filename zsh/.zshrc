## ZSH Plugins
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## Starship - Keep EOF
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
