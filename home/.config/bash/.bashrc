#
# ~/.bashrc
#
# shellcheck source=/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -d ~/.dotfiles ]]; then
    export DOTFILES=~/.dotfiles
fi

source ~/.config/bash/env.bash
source ~/.config/bash/aliases.bash
source ~/.config/bash/completions.bash

# Shell options
shopt -s autocd

# Disable CTRL+S (stop sending output to the terminal)
stty -ixon

# Readline variables
bind "set colored-completion-prefix on"
bind "set mark-directories on"
bind "set mark-symlinked-directories on"


#
#   Prompt
#

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

_color_exit()
{
    # Strip the '\[\]' characters and add them in the prompt,
    # they are interpreted literally otherwise
    local exit=$?
    if [[ $exit -eq 0 ]]; then
        echo "${_green:2:-2}"
    elif [[ $exit -eq 130 ]]; then
        echo "${_yellow:2:-2}"
    else
        echo "${_red:2:-2}"
    fi
}

# Source git prompt if available and check using PREFIX in Termux
for dir in '/usr/share/git/completion' "$PREFIX/etc/bash_completion.d"; do
    if [[ -f $dir/git-prompt.sh ]]; then
        source "$dir/git-prompt.sh"
        break
    fi
done

if command -v __git_ps1 > /dev/null; then
    PS1="$normal$orange\$(__git_ps1 '(%s) ')$purple$italic\u@\h$normal:$blue\w\n\[\$(_color_exit)\]❯$normal "
else
    PS1="$normal$purple$italic\u@\h$normal:$blue\w\n\[\$(_color_exit)\]❯$normal "
fi

PS2="$_green❯$normal "

unset -v normal italic orange blue purple dir

#
#   ssh-agent
#
if ! pgrep --euid "$EUID" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
fi

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
