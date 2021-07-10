function fish_greeting
		 command echo ""
		 command neofetch
end

if status is-interactive
	function ls
	    command exa -al --group-directories-first $argv
	end

	function la
	    command exa -a --group-directories-first $argv
	end

	function l
	    command exa -l --group-directories-first $argv
	end

	function le
	    command exa --group-directories-first $argv
	end

	function lt
	    command exa -aT --group-directories-first $argv
	end

	function l.
	    command exa -a $argv | egrep "^\."
	end

	function em
	    command emacsclient -c -a="" $argv
	end

	function emt
	    command emacsclient -nw -a="" $argv
	end

	function cp
	    command cp -i $argv
	end

	function rm
	    command rm -i $argv
	end

	function mv
	    command mv -i $argv
	end
   # Commands to run in interactive sessions can go here
end
function fish_user_key_bindings
  fish_vi_key_bindings
end
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
set TERM "xterm-256color"
set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal
set VISUAL "emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode
set -x MANPAGER "nvim -c 'set ft=man' -"
fish_add_path $HOME/.emacs.d/bin
