if status is-interactive
    function fish_greeting
    end
    alias ls='exa -al --group-directories-first'
    alias la='exa -a --group-directories-first'
    alias l='exa -l --group-directories-first'
    alias le='exa --group-directories-first'
    alias lt='exa -aT --group-directories-first'
    if test "$XDG_SESSION_TYPE" = 'x11'
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

# if test -n "$DESKTOP_SESSION"
#     for env_var in (gnome-keyring-daemon --start)
#         set -x (echo $env_var | string split "=")
#     end
# end
fish_default_key_bindings

alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if test -e $HOME/.config/fish/gtk_nocsd.fish
    source $HOME/.config/fish/gtk_nocsd.fish
end
if test -e $HOME/.config/fish/bitwarden.fish
    source $HOME/.config/fish/bitwarden.fish
end

set EDITOR "nvim"
set TERMINAL "kitty"
# set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal
set VISUAL "emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode
# set -x MANPAGER 'nvim -M +MANPAGER +"silent %s/^[\[[0-9;]*m//g" -'
# set -x MANPAGER 'nvim -c ASMANPAGER -'
# set -x MANPAGER 'nvim +Man!'
set -x XDG_DATA_DIRS "/usr/local/share/:/usr/share/:/var/lib/flatpak/exports/share/:$HOME/.local/share/flatpak/exports/share"
set -x XDG_CONFIG_HOME "$HOME/.config/"
set --global --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap'

fish_add_path $HOME/.emacs.d/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.npm-global/bin

function vterm_printf; # emacs vterm integration
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

if test -e $HOME/.nvm/nvm.sh
    alias nvm="bass source $HOME/.nvm/nvm.sh --no-use ';' nvm"
    set -x NVM_DIR "$HOME/.nvm"
    bass source $HOME/.nvm/nvm.sh
end

# pnpm
set -gx PNPM_HOME "/home/limber502/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
