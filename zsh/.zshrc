# --- ZSH PLugins ---
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- Mise ---
eval "$(mise activate zsh)"

# --- Starship :: Keep EOF ---
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# Homebrew OCLP patch - auto-reapply after brew update
brew() {
    command brew "$@"
    local ret=$?
    if [[ "$1" == "update" ]]; then
        curl -sL "https://raw.githubusercontent.com/ajorpheus/homebrew-oclp-patches/master/homebrew-oclp.patch" | git -C /usr/local/Homebrew apply 2>/dev/null && echo "OCLP patches restored"
    fi
    return $ret
}
