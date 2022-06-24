#!/usr/bin/env bash
set -euo pipefail

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare https://github.com/ninoDeme/dotfiles $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
echo ".dotfiles" >> .gitignore
/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME reset --hard HEAD
echo use \"/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME\" to manage the repository, you can alias it to anything
