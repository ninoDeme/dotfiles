# .bash_profile

if command -v ssh-agent &> /dev/null
then
  eval `ssh-agent -s`
fi

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

if [ -d "$HOME/.local/bin" ] ; then PATH="$HOME/.local/bin:$PATH"; fi
if [ -d "$HOME/.config/emacs/bin" ] ; then PATH="$HOME/.config/emacs/bin:$PATH"; fi
if [ -d "$XDG_DATA_HOME/cargo/bin" ] ; then PATH="$XDG_DATA_HOME/cargo/bin:$PATH"; fi
if [ -d "$XDG_DATA_HOME/asdf/" ] ; then source "$XDG_DATA_HOME/asdf/asdf.sh"; fi

export DENO_INSTALL="$XDG_DATA_HOME/deno"
if [ -d "$XDG_DATA_HOME/deno" ]; then
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

export DOTNET_INSTALL_DIR="$XDG_DATA_HOME/dotnet"
export DOTNET_ROOT="$XDG_DATA_HOME/dotnet"
if [ -d "$XDG_DATA_HOME/dotnet" ]; then
  export PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH"
fi

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ] ;
then
  source $HOME/.nix-profile/etc/profile.d/nix.sh
fi # added by Nix installer


# Get the aliases and functions
[ -f $HOME/.bashrc ] && . $HOME/.bashrc

export VOLTA_HOME="$XDG_DATA_HOME/volta"
if [ -d "$VOLTA_HOME" ]; then
  export PATH="$VOLTA_HOME/bin:$PATH"
fi

export SDKMAN_DIR="$XDG_DATA_HOME/sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] then source "$SDKMAN_DIR/bin/sdkman-init.sh"; fi

