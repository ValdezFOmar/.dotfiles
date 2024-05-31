#
# ~/.bashrc
#
# shellcheck source=/dev/null

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


#
#   Enviroment Variables
#
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export MDCAT_PAGER='less --raw-control-chars --quit-if-one-screen'

export DOTFILES="$HOME/.dotfiles"

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export PIPX_BIN_DIR="$HOME/bin"
export POETRY_VIRTUALENVS_IN_PROJECT=true
export POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=true
export POETRY_VIRTUALENVS_PROMPT=  # Set at prompt section

# https://github.com/tldr-pages/tldr-python-client#colors
export TLDR_COLOR_NAME="green underline"
export TLDR_COLOR_DESCRIPTION=""
export TLDR_COLOR_EXAMPLE=""
export TLDR_COLOR_COMMAND="blue"
export TLDR_COLOR_PARAMETER="red"

# See fzf(1)
export FZF_DEFAULT_OPTS="
--layout=reverse --border --prompt='choose❯ ' --pointer=❯ --marker=❯

--color=fg:#63677f,fg+:white:regular,hl:cyan,hl+:cyan,query:white:regular
--color=bg+:-1,bg+:-1,border:bright-black
--color=prompt:blue:regular,label:blue,header:blue
--color=pointer:green,info:green,spinner:cyan,marker:magenta
"

#
#   Path
#
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"


#
#   Aliases and functions
#
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"


#
#   Completion
#
[ -f "$HOME/.bash_completion" ] && source "$HOME/.bash_completion"


#
#   Readline variables
#
bind "set colored-completion-prefix on"
bind "set mark-directories on"
bind "set mark-symlinked-directories on"


#
#   Prompt
#

normal=$(tput sgr0)
# black=$(tput setaf c)
red=$(tput setaf 1)
green=$(tput setaf 2)
orange=$(tput setaf 3)
blue=$(tput setaf 4)
purple=$(tput setaf 5)
# cyan=$(tput setaf 6)
# white=$(tput setaf 7)
yellow=$(tput setaf 11)

POETRY_VIRTUALENVS_PROMPT="\[${green}\]poetry-{python_version}\[${normal}\]"

__color_exit()
{
    local exit=$?
    if [[ $exit -eq 0 ]]; then
        echo "$green"
    elif [[ $exit -eq 130 ]]; then
        echo "$yellow"
    else
        echo "$red"
    fi
}

# Simple prompt
#PS1='\u@\h \w$ '

# User name in italics
# '❯' is green if there's no errors, otherwise red
#
# TODO: A possible alternative prompt to use instead of hacking things with CR/LF
# PS1="$(__git_ps1 '(%s) ')\u@\h:\w\n❯ "

# Add git prompt if it exists
if [[ -f ~/.git-prompt.sh ]]; then
    source ~/.git-prompt.sh
    # FIXME: Better solution for this crazy escape sequences
    PS1='\[${normal}\]\[${purple}\]\[\e[3m\]\u\[\e[23m\] \[${blue}\]\w\[${orange}\]$(__git_ps1)\[$(__color_exit)\]❯\[${normal}\] '
else
    PS1='\[${normal}\]\[${purple}\]\[\e[3m\]\u\[\e[23m\] \[${blue}\]\w\[$(__color_exit)\]❯\[${normal}\] '
fi

PS2="\[${green}\]❯\[${normal}\] "


#
#   Programs Integrations
#

# Disable CTRL+S (stop sending output to the terminal)
stty -ixon

# ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
