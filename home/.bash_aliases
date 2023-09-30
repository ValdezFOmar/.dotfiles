#!/bin/bash

# shellcheck source=/dev/null

#   Aliases
#   =======

# Space for expanding command aliases when using sudo
#alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -AvF'
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
alias disk='df -H --type=ext4'


#   Functions
#   =========

cl()
{
    if [ -z "$1" ]; then
        echo "cl: No directory provided"
        return 1
    fi
    la -- "$1" && cd -- "$1" || return 1
}

mcd()
{
    if [ -z "$1" ]; then
        echo "mcd: No name provided"
        return 1
    fi
    mkdir -p -- "$1" && cd -P -- "$1" || return 1
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

# Create virtual env
venv()
{
    venv_name=".venv"

    if [ -d "$venv_name" ]; then
        echo "'$venv_name' already exists"
        return
    fi

    echo "Creating virtual enviroment..."
    python -m venv "./$venv_name" --prompt "\[$(tput setaf 2)\]$venv_name\[$(tput sgr0)\]"
    activate
    pip -V

    if [ -f ./requirements.txt ]; then
        printf "Install from 'requirements.txt' file? (y/n) "
        read -r answer
        if [ "$answer" = "y" ]; then
            pip install -r ./requirements.txt
        fi
    fi
}
