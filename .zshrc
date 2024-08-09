# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

bindkey -e

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" --depth 1
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-history-substring-search
# zinit light bobsoppe/zsh-ssh-agent


bindkey '\eOA' history-substring-search-up # or '\eOA'
bindkey '\eOB' history-substring-search-down # or '\eOB'

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

export XDG_CONFIG_HOME="$HOME/.config"

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ] ;
  then PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/.config/emacs/bin" ] ;
  then PATH="$HOME/.config/emacs/bin:$PATH"
fi

if command -v go &> /dev/null
  then export GOBIN=$(go env GOPATH)/bin
fi
if [ -d "$GOBIN" ] ;
  then PATH="$GOBIN:$PATH"
fi

if [ -d "$HOME/.npm-global/bin" ] ;
  then PATH="$HOME/.npm-global/bin:$PATH"
fi

export TERM="xterm-256color"                      # getting proper colors

PS1="%F{green}%n@%m%f %F{blue}%~%f%(?..%F{red} [%?]%f)$ "

if command -v exa &> /dev/null
then
	alias la='exa -a --group-directories-first'
	alias l='exa -al --group-directories-first'
	alias le='exa --group-directories-first'
	alias lt='exa -aT --group-directories-first'
fi

alias emt='emacsclient -nw -a=\"\"'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export EDITOR="nvim"

if ! command -v nvim &> /dev/null
then
	export EDITOR="vim"
fi

export MANPAGER="nvim -c Man! -"
export XDG_DATA_DIRS="/usr/local/share/:/usr/share/:/var/lib/flatpak/exports/share/:$HOME/.local/share/flatpak/exports/share"

case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

fpath+=~/.zfunc

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Lines configured by zsh-newuser-install
#
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
unsetopt beep notify

# NVM npm version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/ricardo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [ -d "$HOME/.asdf/" ] ;
then
  . "$HOME/.asdf/asdf.sh"
  fpath=(${ASDF_DIR}/completions $fpath)
fi

[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

zstyle :compinstall filename '/home/nino/.zshrc'
autoload -Uz compinit
compinit

# case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

zstyle ':completion::complete:*' gain-privileges 1

if [ -e /home/nino/.nix-profile/etc/profile.d/nix.sh ]; then . /home/nino/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
