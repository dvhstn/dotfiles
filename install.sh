#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Installing Homebrew (if needed)"
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> Installing packages and fonts from Brewfile"
brew bundle --file="$DOTFILES_DIR/Brewfile"

echo "==> Installing mise (via its own installer, not Homebrew)"
if ! command -v mise &>/dev/null; then
  curl -fsSL https://mise.run | sh
fi

echo "==> Symlinking zsh config"
ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

echo "==> Symlinking starship config"
mkdir -p "$HOME/.config/starship"
ln -sf "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"

echo "==> Setting global gitignore"
git config --global core.excludesfile "$DOTFILES_DIR/git/.gitignore"

echo "==> Pointing iTerm2 at dotfiles preferences"
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

echo "==> Done. Restart your terminal (or run 'exec zsh') to pick up changes."
echo "    Set your terminal font to 'JetBrainsMono Nerd Font' in iTerm2 if it isn't already."
