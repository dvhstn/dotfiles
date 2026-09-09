#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"
# No "latest" alias is published; bump this when you want a newer build.
GHOSTTY_VERSION="1.3.1"

echo "==> Installing starship"
if ! command -v starship &>/dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin" >/dev/null
fi

echo "==> Installing Ghostty"
if [ ! -d "/Applications/Ghostty.app" ]; then
  TMP_DMG="$(mktemp -t ghostty).dmg"
  curl -fsSL -o "$TMP_DMG" "https://release.files.ghostty.org/${GHOSTTY_VERSION}/Ghostty.dmg"
  MOUNT_POINT="$(hdiutil attach "$TMP_DMG" -nobrowse -quiet | tail -1 | awk '{print $NF}')"
  cp -R "$MOUNT_POINT/Ghostty.app" /Applications/
  hdiutil detach "$MOUNT_POINT" -quiet
  rm -f "$TMP_DMG"
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

echo "==> Symlinking Ghostty config"
mkdir -p "$HOME/.config/ghostty"
for f in "$DOTFILES_DIR"/ghostty/*; do
  ln -sf "$f" "$HOME/.config/ghostty/$(basename "$f")"
done

echo "==> Done. Restart your terminal (or run 'exec zsh') to pick up changes."
