
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100          # limits recursive functions, see 'man bash'

# Set prompt
PS1="\[\033[1;33m\][\[\033[1;36m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h\[\033[1;37m\]:\[\033[1;31m\]\w\[\033[1;33m\]]\[\033[1;37m\]>\[\033[0m\] "

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

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


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
