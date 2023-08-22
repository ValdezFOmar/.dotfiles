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
#PS1='\u@\h \w > '
PS1="\e[35m\e[3m\u\e[23m \e[34m\w\e[32m$\e(B\e[m "


# Auto cd when typing a directory
shopt -s autocd


# Set path so it includes /bin and /.local/bin if it exists
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
