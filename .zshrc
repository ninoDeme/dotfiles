# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/nino/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
##Set nvim as man pager
export MANPAGER="nvim -c 'set ft=man' -"

## Change ls to exa
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing

## Confirm before overwriting
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

export EDITOR='nvim'
export TERM="xterm-256color"
# Git bare repository

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#zinit plugins

zinit wait lucid for zinit-zsh/zinit-console
zinit pack for fzf
zinit light zdharma/zui/
zinit light mafredri/zsh-async
zinit light changyuheng/fz
zinit light rupa/z
zinit light zsh-users/zsh-autosuggestions
zinit light hcgraf/zsh-sudo
zinit light jreese/zsh-titles
zinit light zsh-users/zsh-completions
zinit light MenkeTechnologies/zsh-cargo-completion
# zinit snippet 'https://github.com/lincheney/fzf-tab-completion/blob/master/zsh/fzf-zsh-completion.sh'
# bindkey '^I' fzf_completion
# zinit light marlonrichert/zsh-autocomplete
zinit ice depth=1; zinit light romkatv/powerlevel10k
# eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
