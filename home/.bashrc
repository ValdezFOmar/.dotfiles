#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Enviroment Variables
export EDITOR="nano"
export DOTFILES="$HOME/.dotfiles"


# Source aliases
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"


# Prompt

## Colors
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
orange=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
normal=$(tput sgr0)

color_exit_status()
{
    if [[ $? == 0 ]]; then
        echo $green
    else
        echo $red
    fi
}

# Simple prompt
#PS1='\u@\h \w$ '

# User name in italics
# '$' is green if there's no errors, otherwise red
PS1='\[${purple}\]\[\e[3m\]\u\[\e[23m\] \[${blue}\]\w\[$(color_exit_status)\]$\[${normal}\] '


# Auto cd when typing a directory
shopt -s autocd


# Set path so it includes /bin and /.local/bin if it exists
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
