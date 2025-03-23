# shellcheck shell=bash source=/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.config/bash/env.bash
source ~/.config/bash/aliases.bash
source ~/.config/bash/completions.bash

# Shell options
shopt -s autocd

# Disable CTRL+S (stop sending output to the terminal)
stty -ixon

#
#   Prompt
#

# TODO:
# - Put configuration into a 'setup' function to avoid cluttering the
#   environment with all this variables
# - Use literal scape sequences instead of calling an external command
# - Remove unused variables
normal="\[$(tput sgr0)\]"
italic="\[$(tput sitm)\]"
# black="\[$(tput setaf c)\]"
_red="\[$(tput setaf 1)\]"
_green="\[$(tput setaf 2)\]"
orange="\[$(tput setaf 3)\]"
blue="\[$(tput setaf 4)\]"
purple="\[$(tput setaf 5)\]"
# cyan="\[$(tput setaf 6)\]"
# white="\[$(tput setaf 7)\]"
_yellow="\[$(tput setaf 11)\]"

function -set-exit-color() {
    local exit=$?
    if ((exit == 0)); then
        printf '\e[32m' # green
    elif ((exit == 130)); then
        printf '\e[93m' # yellow
    else
        printf '\e[31m' # red
    fi
}
readonly -f -- -set-exit-color

# Source git prompt if available and check using PREFIX in Termux
for dir in '/usr/share/git/completion' "$PREFIX/etc/bash_completion.d"; do
    if [[ -f $dir/git-prompt.sh ]]; then
        source "$dir/git-prompt.sh"
        break
    fi
done

# TODO:
# pull git prompt into a variable and set it to the empty string if __git_ps1 is not defined
# this way the prompt is only defined once
if command -v __git_ps1 > /dev/null; then
    PS1="$normal$orange\$(__git_ps1 '(%s) ')$purple$italic\u@\h$normal:$blue\w\n\[\$(-set-exit-color)\]❯$normal "
else
    PS1="$normal$purple$italic\u@\h$normal:$blue\w\n\[\$(-set-exit-color)\]❯$normal "
fi

PS2="$_green❯$normal "

unset -v normal italic orange blue purple dir

#
#   pyenv
#
export PYENV_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/pyenv"
if command -v pyenv > /dev/null; then
    eval "$(pyenv init -)"
elif [[ -x $PYENV_ROOT/bin/pyenv ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi
