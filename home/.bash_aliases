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
