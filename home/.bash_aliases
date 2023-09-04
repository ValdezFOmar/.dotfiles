#!/bin/bash


#   Aliases
#   =======

# Space for expanding command aliases when using sudo
#alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -Av1F'
alias ll='ls -AlvGh'

alias rm='rm -I '
alias md='mkdir '

alias cd..='cd ..'
alias vim='nvim '
alias kssh='kitty +kitten ssh'

alias py='python'
alias pip='pip --require-virtualenv'

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

# activate virtual env
activate()
{
    if [[ -d ./.venv ]]; then
        if [[ -f ./.venv/bin/activate ]]; then
            . ./.venv/bin/activate
        else
            echo "Theres no file for virtual enviroment"
        fi
    else
        echo "Theres no '.venv' directory"
    fi
}

# Creare virtual env
venv()
{
    venv_name=".venv"

    if [ -d "$venv_name" ]; then
        echo "'$venv_name' already exists"
        return
    fi

    python -m venv "./$venv_name" --prompt "\[$(tput setaf 2)\]$venv_name\[$(tput sgr0)\]"
    activate
}
