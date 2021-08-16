#!/usr/bin/env bash
set -euo pipefail

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare https://github.com/ninodemeterko/dotfiles $HOME/.dotfiles
config config --local status.showUntrackedFiles no
