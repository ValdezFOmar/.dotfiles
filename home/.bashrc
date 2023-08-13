#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source aliases
[[ -e "$HOME/.bash_aliases" ]] && . "$HOME/.bash_aliases"

# Prompt
PS1='\u@\h \w > '

shopt -s autocd