#!/usr/bin/env bash
# Creates symlinks in $HOME pointing into this repo's files.
# Safe to re-run: skips files already linked correctly, and backs up
# (never deletes) anything else already present at the target path.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# target (relative to $HOME) -> source (relative to $DOTFILES_DIR)
LINKS=(
  ".vimrc:vimrc"
  ".vim:vim"
  ".gitconfig:gitconfig"
  ".tigrc:tigrc"
  ".Brewfile:Brewfile"
)

for entry in "${LINKS[@]}"; do
  target_name="${entry%%:*}"
  source_name="${entry##*:}"
  target_path="$HOME/$target_name"
  source_path="$DOTFILES_DIR/$source_name"
  link_value="dotfiles/$source_name"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$link_value" ]; then
    echo "ok: $target_name already linked"
    continue
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_path="${target_path}.backup.$(date +%Y%m%d%H%M%S)"
    echo "backing up existing $target_name -> $(basename "$backup_path")"
    mv "$target_path" "$backup_path"
  fi

  ln -s "$link_value" "$target_path"
  echo "linked: $target_name -> $link_value"
done

echo "Done. Verify with: ls -la \"$HOME\" | grep -E '\\.vimrc|\\.vim$|\\.gitconfig|\\.tigrc|\\.Brewfile'"
