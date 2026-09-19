#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Backing up existing $dest -> $dest.bak"
    mv "$dest" "$dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

echo "==> Symlinking configs"
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"
link "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

echo "==> Configuring git"
git config --global core.excludesfile "$HOME/.gitignore_global"

echo "==> Checking for Homebrew"
if command -v brew >/dev/null 2>&1; then
  echo "Homebrew found at $(brew --prefix) — brew-based package installs will go here."
else
  echo "Homebrew not found — using vendored zsh plugins via git submodules."
  git -C "$DOTFILES_DIR" submodule update --init --recursive
fi

echo "==> Done"
