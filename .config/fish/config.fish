if status is-interactive
	function fish_greeting
	end
	alias ls='exa -al --group-directories-first'
	alias la='exa -a --group-directories-first'
	alias l='exa -l --group-directories-first'
	alias le='exa --group-directories-first'
	alias lt='exa -aT --group-directories-first'
	if test $XDG_SESSION_TYPE = 'x11'
		alias em='devour emacsclient -c -a=\"\"'
	else
		alias em='emacsclient -c -a=\"\"'
	end
	alias emt='emacsclient -nw -a=\"\"'
	alias cp='cp -i'
	alias rm='rm -i'
	alias mv='mv -i'
	function mkexec
	    command chmod u+x
	end
end
set --global --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap'
fish_default_key_bindings
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal
# set VISUAL "devour emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode
set EDITOR "nvim"
set -x MANPAGER "nvim -c 'set ft=man' -"
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/.cargo/bin
