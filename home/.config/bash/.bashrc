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

# TODO:
# - Make function read only
# - Use printf instead of echo
# - Inline color variables (easier with printf escape sequences)
# - unprefix and use kebab case
_color_exit() {
    # Strip the '\[\]' characters and add them in the prompt,
    # they are interpreted literally otherwise
    local exit=$?
    if [[ $exit -eq 0 ]]; then
        echo "${_green:2:-2}" # green
    elif [[ $exit -eq 130 ]]; then
        echo "${_yellow:2:-2}" # yellow
    else
        echo "${_red:2:-2}" # red
    fi
}

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
    PS1="$normal$orange\$(__git_ps1 '(%s) ')$purple$italic\u@\h$normal:$blue\w\n\[\$(_color_exit)\]❯$normal "
else
    PS1="$normal$purple$italic\u@\h$normal:$blue\w\n\[\$(_color_exit)\]❯$normal "
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
