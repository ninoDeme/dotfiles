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
	function fconf
	    command nvim $HOME/.config/fish/config.fish
	end
	function nvimconf
	    pushd $HOME/.config/nvim/
	    command nvim init.lua
	    popd
	end
end

function vterm_printf; #emacs vterm integration
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end 
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

if test -n "$DESKTOP_SESSION"
    for env_var in (gnome-keyring-daemon --start)
        set -x (echo $env_var | string split "=")
    end
end
set --global --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap'
fish_default_key_bindings
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal
# set VISUAL "devour emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode
if test -e $HOME/.config/fish/gtk_nocsd.fish
	source $HOME/.config/fish/gtk_nocsd.fish
end
if test -e $HOME/.config/fish/bitwarden.fish
	source $HOME/.config/fish/bitwarden.fish
end
set EDITOR "nvim"
# set -x MANPAGER 'nvim -M +MANPAGER +"silent %s/^[\[[0-9;]*m//g" -'
set -x MANPAGER 'nvim -c MANPAGER -'
set -x XDG_DATA_DIRS "/usr/local/share/:/usr/share/:/var/lib/flatpak/exports/share/:$HOME/.local/share/flatpak/exports/share"
fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.npm-global/bin



set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/nino/.ghcup/bin $PATH # ghcup-env
