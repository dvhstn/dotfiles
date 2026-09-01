#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"

echo "==> Installing starship"
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

echo "==> Installing zsh plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

if [ -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  git -C "$ZSH_PLUGINS_DIR/zsh-autosuggestions" pull --ff-only
else
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ -d "$ZSH_PLUGINS_DIR/fast-syntax-highlighting" ]; then
  git -C "$ZSH_PLUGINS_DIR/fast-syntax-highlighting" pull --ff-only
else
  git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_PLUGINS_DIR/fast-syntax-highlighting"
fi

echo "==> Installing JetBrains Mono Nerd Font"
if [ ! -f "$HOME/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf" ]; then
  TMP_ZIP="$(mktemp -t jetbrains-mono-nerd-font).zip"
  curl -fsSL -o "$TMP_ZIP" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -o -q "$TMP_ZIP" -d "$HOME/Library/Fonts" "*.ttf"
  rm -f "$TMP_ZIP"
fi

echo "==> Installing mise"
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
