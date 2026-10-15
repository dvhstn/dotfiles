#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
MISE="$HOME/.local/bin/mise"
# Identity stays machine-local in ~/.config/git/config; never tracked here
GIT_CONFIG="$HOME/.config/git/config"

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

# Prompts until a non-empty answer is given; $2 must be a substring of the answer
ask() {
  local prompt="$1" must_contain="${2:-}" answer=""
  while [ -z "$answer" ] || [[ "$answer" != *"$must_contain"* ]]; do
    read -r -p "$prompt" answer </dev/tty
  done
  echo "$answer"
}

# Asked up front so the rest of the install runs unattended.
# --global covers both ~/.gitconfig and ~/.config/git/config.
# Only values asked for here are saved; an existing identity is left alone.
GIT_NAME="" GIT_EMAIL=""
HAS_NAME="$(git config --global user.name || true)"
HAS_EMAIL="$(git config --global user.email || true)"
if [ -z "$HAS_NAME" ] || [ -z "$HAS_EMAIL" ]; then
  if { : </dev/tty; } 2>/dev/null; then
    echo "==> Git identity (saved to ~/.config/git/config only)"
    [ -n "$HAS_NAME" ] || GIT_NAME="$(ask "Git user.name: ")"
    [ -n "$HAS_EMAIL" ] || GIT_EMAIL="$(ask "Git user.email: " "@")"
  else
    echo "No terminal to prompt for git identity; set it later with:"
    echo "  git config --file ~/.config/git/config user.name \"Your Name\""
    echo "  git config --file ~/.config/git/config user.email \"you@example.com\""
  fi
fi

echo "==> Fetching zsh plugins"
git -C "$DOTFILES_DIR" submodule update --init --recursive

echo "==> Symlinking configs"
link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES_DIR/ghostty/config.ghostty" "$HOME/.config/ghostty/config.ghostty"
link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"
link "$DOTFILES_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"
link "$DOTFILES_DIR/git/.gitignore" "$HOME/.config/git/.global_gitignore"

echo "==> Configuring git"
mkdir -p "$(dirname "$GIT_CONFIG")"
git config --file "$GIT_CONFIG" core.excludesFile "~/.config/git/.global_gitignore"
[ -z "$GIT_NAME" ] || git config --file "$GIT_CONFIG" user.name "$GIT_NAME"
[ -z "$GIT_EMAIL" ] || git config --file "$GIT_CONFIG" user.email "$GIT_EMAIL"

echo "==> Installing mise tools"
if [ ! -x "$MISE" ]; then
  curl -fsSL https://mise.run | sh
fi
"$MISE" trust "$HOME/.config/mise/config.toml"
"$MISE" install

echo "==> Done. Restart your shell."
