# shellcheck shell=bash source=/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prevent script from being sourced multiple times
[[ -n $_BONES_LOADED_BASHRC ]] && return
readonly _BONES_LOADED_BASHRC=true

source ~/.config/bash/env.bash
source ~/.config/bash/aliases.bash
source ~/.config/bash/completions.bash

# Shell options
shopt -s autocd
shopt -s failglob
shopt -s histappend

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

function set-prompt() {
    # Source git prompt if available and check with PREFIX in Termux
    local dir
    for dir in '/usr/share/git/completion' "$PREFIX/etc/bash_completion.d"; do
        if [[ -r $dir/git-prompt.sh ]]; then
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

    local gitprompt=''
    command -v __git_ps1 > /dev/null && gitprompt="$o\$(__git_ps1 '(%s) ')$n"

    export PS1="$n$gitprompt$p$i\u@\h$n:$b\w\n\[\$(-set-exit-color)\]❯$n "
    export PS2="\[\$(-set-exit-color)\]❯$n "
}

set-prompt
unset -f set-prompt
