#
# ~/.bashrc
#
# shellcheck source=/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Enviroment Variables
# ====================
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export DOTFILES="$HOME/.dotfiles"
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true


# Source aliases
# ==============
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"


# Prompt
# ======

## Colors
# black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
orange=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
# cyan=$(tput setaf 6)
# white=$(tput setaf 7)
normal=$(tput sgr0)

color_exit_status()
{
    if [[ $? == 0 ]]; then
        echo "$green"
    else
        echo "$red"
    fi
}

# Simple prompt
#PS1='\u@\h \w$ '

# User name in italics
# '❯' is green if there's no errors, otherwise red

# Add git prompt if it exists
if [[ -f ~/.git-prompt.sh ]]; then
    . ~/.git-prompt.sh
    PS1='\[${purple}\]\[\e[3m\]\u\[\e[23m\] \[${blue}\]\w\[${orange}\]$(__git_ps1 " (%s)")\[$(color_exit_status)\]❯\[${normal}\] '
else
    PS1='\[${purple}\]\[\e[3m\]\u\[\e[23m\] \[${blue}\]\w\[$(color_exit_status)\]❯\[${normal}\] '
fi

PS2="\[${green}\]❯\[${normal}\] "


# Completition
# ============

# git bash completion
[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash

# Auto cd when typing a directory
shopt -s autocd


# ssh-agent
# =========
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi


# Path
# ====
# Set path so it includes /bin and /.local/bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
# command -v notes >/dev/null && notes

# pyenv shell integration
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Ruby shell inetgration TO BE REMOVE
eval "$(~/.rbenv/bin/rbenv init - bash)"
