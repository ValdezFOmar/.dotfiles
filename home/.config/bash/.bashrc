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

function setup-prompt() {
    # Source git prompt if available and check using PREFIX in Termux
    local dir
    for dir in '/usr/share/git/completion' "$PREFIX/etc/bash_completion.d"; do
        if [[ -f $dir/git-prompt.sh ]]; then
            source "$dir/git-prompt.sh"
            break
        fi
    done

    local n i o b p
    printf -v n '\[\e[0m\]'  # normal/reset
    printf -v i '\[\e[3m\]'  # italic
    printf -v o '\[\e[33m\]' # orange
    printf -v b '\[\e[34m\]' # blue
    printf -v p '\[\e[35m\]' # purple

    # TODO:
    # pull git prompt into a variable and set it to the empty string if __git_ps1 is not defined
    # this way the prompt is only defined once
    if command -v __git_ps1 > /dev/null; then
        PS1="$n$o\$(__git_ps1 '(%s) ')$p$i\u@\h$n:$b\w\n\[\$(-set-exit-color)\]❯$n "
    else
        PS1="$n$p$i\u@\h$n:$b\w\n\[\$(-set-exit-color)\]❯$n "
    fi

    PS2="\[\$(-set-exit-color)\]❯$n "
}

setup-prompt
unset -f setup-prompt

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
