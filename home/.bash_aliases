#!/bin/bash


#   Aliases
#   =======

# Space for expanding command aliases when using sudo
alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -Av1'
alias ll='ls -Alv'

alias rm='rm -i '
alias md='mkdir '

alias cd..='cd ..'

#alias nano="nano --rcfile $HOME/.nanorc"



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
