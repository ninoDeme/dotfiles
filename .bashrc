
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

# Set prompt
# PS1="\[\033[1;33m\][\[\033[1;36m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h\[\033[1;37m\]:\[\033[1;31m\]\w\[\033[1;33m\]]\[\033[1;37m\]>\[\033[0m\] "
PS1_PROMPT() {
  local e=$?
  (( e )) && printf " \033[01;31m[$e]\033[00m"  # color
  return $e
}
PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]$(PS1_PROMPT)\$ '

# export TERM="xterm-256color"                      # getting proper colors

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ] ;
  then PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/.config/emacs/bin" ] ;
  then PATH="$HOME/.config/emacs/bin:$PATH"
fi

if command -v exa &> /dev/null
then
	alias la='exa -a --group-directories-first'
	alias l='exa -al --group-directories-first'
	alias le='exa --group-directories-first'
	alias lt='exa -aT --group-directories-first'
fi

alias emt='emacsclient -nw -a=\"\"'
alias cp='cp -i'
alias rm='rm -I'
alias mv='mv -i'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if command -v nvim &> /dev/null
then
  export MANPAGER="nvim -c Man! -"
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi


export XDG_DATA_DIRS="/usr/local/share/:/usr/share/:/var/lib/flatpak/exports/share/:$HOME/.local/share/flatpak/exports/share"

case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# alias pacdiff=eos-pacdiff
################################################################################

# bash-sensible
set -o noclobber # Prevent file overwrite on stdout redirect. Use `>|` to force redirection to an existing file
shopt -s checkwinsize # Update window size after every command
PROMPT_DIRTRIM=2 # Automatically trim long paths in the prompt (requires Bash 4.x)
bind Space:magic-space # Enable history expansion with space E.g. typing !!<space>
shopt -s globstar 2> /dev/null # Turn on recursive globbing (enables ** to recurse all directories)
shopt -s nocaseglob; # Case-insensitive globbing (used in pathname expansion)

## SMARTER TAB-COMPLETION (Readline bindings) ##
bind "set completion-ignore-case on" # Perform file completion in a case insensitive fashion
bind "set completion-map-case on" # Treat hyphens and underscores as equivalent
bind "set show-all-if-ambiguous on" # Display matches for ambiguous patterns at first tab press
bind "set mark-symlinked-directories on" # Immediately add a trailing slash when autocompleting symlinks to directories

## SANE HISTORY DEFAULTS ##

shopt -s histappend # Append to the history file, don't overwrite it
shopt -s cmdhist # Save multi-line commands as one command

PROMPT_COMMAND='history -a' # Record each line as it gets issued
HISTSIZE=500000 # Huge history. Doesn't appear to slow things down, so why not?
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth" # Avoid duplicate entries
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear" # Don't record some commands

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

## BETTER DIRECTORY NAVIGATION ##
shopt -s autocd 2> /dev/null # Prepend cd to directory names automatically
shopt -s dirspell 2> /dev/null # Correct spelling errors during tab-completion
shopt -s cdspell 2> /dev/null # Correct spelling errors in arguments supplied to cd

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH="."

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars

# Examples:
# export dotfiles="$HOME/dotfiles"
# export projects="$HOME/projects"
# export documents="$HOME/Documents"
# export dropbox="$HOME/Dropbox"

# if [ -x /usr/bin/fzf ] ; then
#   # Set up fzf key bindings and fuzzy completion
#   eval "$(fzf --bash)"
#   return
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -s "/etc/profile.d/bash_completion.sh" ] && \. "/etc/profile.d/bash_completion.sh"

[ -f "$HOME/.ghcup/env" ] && source "/home/nino/.ghcup/env" # ghcup-env
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if command -v go &> /dev/null
  then export GOBIN=$(go env GOPATH)/bin
fi
if [ -d "$GOBIN" ] ;
  then PATH="$GOBIN:$PATH"
fi

if [ -d "$HOME/.npm-global/bin" ] ;
  then PATH="$HOME/.npm-global/bin:$PATH"
fi

# pnpm
export PNPM_HOME="/home/ricardo/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [ -d "$HOME/.deno/" ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -d "$HOME/.asdf/" ] ;
then
  source "$HOME/.asdf/asdf.sh"
fi

# [[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ] ;
then
  source $HOME/.nix-profile/etc/profile.d/nix.sh
fi # added by Nix installer

