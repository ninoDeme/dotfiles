#!/usr/bin/env bash
set -euo pipefail

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/ninoDeme/dotfiles $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
echo ".dotfiles" >> .gitignore
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME reset --hard HEAD
