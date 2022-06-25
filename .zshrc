# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

_open_files_for_editing() {
    # Open any given document file(s) for editing (or just viewing).
    # Note1:
    #    - Do not use for executable files!
    # Note2:
    #    - Uses 'mime' bindings, so you may need to use
    #      e.g. a file manager to make proper file bindings.

    if [ -x /usr/bin/exo-open ] ; then
        echo "exo-open $@" >&2
        setsid exo-open "$@" >& /dev/null
        return
    fi
    if [ -x /usr/bin/xdg-open ] ; then
        for file in "$@" ; do
            echo "xdg-open $file" >&2
            setsid xdg-open "$file" >& /dev/null
        done
        return
    fi

    echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}

if command -v exa &> /dev/null
then
	alias ls='exa -al --group-directories-first'
	alias la='exa -a --group-directories-first'
	alias l='exa -l --group-directories-first'
	alias le='exa --group-directories-first'
	alias lt='exa -aT --group-directories-first'
fi

alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing

alias emt='emacsclient -nw -a=\"\"'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
export EDITOR="nvim"
# set -x MANPAGER 'nvim -M +MANPAGER +"silent %s/^[\[[0-9;]*m//g" -'
export MANPAGER="nvim -c MANPAGER -"
export XDG_DATA_DIRS="/usr/local/share/:/usr/share/:/var/lib/flatpak/exports/share/:$HOME/.local/share/flatpak/exports/share"

PATH="$HOME/.emacs.d/bin:$PATH"
if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.npm-global/bin:$PATH"

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# alias pacdiff=eos-pacdiff
################################################################################
# pure prompt config
fpath+=($HOME/.config/zsh/pure)
autoload -U promptinit; promptinit
zstyle ':prompt:pure:prompt:success' color 040
prompt pure

export ZPWR_EXPAND_TO_HISTORY=true
export ZPWR_EXPAND_PRE_EXEC_NATIVE=true
# Lines configured by zsh-newuser-install
#
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nino/.zshrc'
autoload -Uz compinit
compinit

zstyle ':completion::complete:*' gain-privileges 1

# End of lines added by compinstall
# NVM npm version manager
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

eval "$(sheldon source)"
