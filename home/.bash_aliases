#!/bin/bash


#   Aliases
#   =======

# Space for expanding command aliases when using sudo
#alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -Av1F'
alias ll='ls -AlvGh'

alias rm='rm -i '
alias md='mkdir '

alias cd..='cd ..'
alias py='python -q'
alias vim='nvim '
alias kssh='kitty +kitten ssh'

alias cal='cal --monday'
alias month='cal --one'
alias calendar='cal --year'


#   Functions
#   =========

cl()
{
    la -- $1 && cd -- $1
}

mcd()
{
    mkdir -p -- $1 && cd -P -- $1
}
