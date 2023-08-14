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


# Set path so it includes /bin and /.local/bin if it exists
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
