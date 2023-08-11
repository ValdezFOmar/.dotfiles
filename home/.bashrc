#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Prompt
PS1='\u@\h:\w> '

shopt -s autocd


# Aliases

# Space for expanding command aliases when using sudo
alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias la='ls -Av'
alias ll='ls -Alv'

alias nano="nano --rcfile $HOME/.nanorc"

cl()
{
    ll $1 && cd $1
}
