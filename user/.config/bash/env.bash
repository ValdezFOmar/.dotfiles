# shellcheck disable=SC2155

# Environmental variables for CLI only programs.
# UI and other environmental variables are defined in ~/.xprofile
# so they are available during the session and not only in the shell

function history-path() {
    local fallback="$HOME/.local/state"
    local dir_state="${XDG_STATE_HOME:-$fallback}/$1"
    [[ -d $dir_state ]] || mkdir --parents "$dir_state"
    echo -n "$dir_state/history"
}

# bash(1) "Shell Variables" section
export HISTCONTROL=ignoredups
export HISTIGNORE='ls *:la *:ll *:cd *'
export HISTFILE=$(history-path bash)

# python 3.13+ only
export PYTHON_HISTORY=$(history-path python)
export NODE_REPL_HISTORY=$(history-path node)

# Use italics instead of underlines
export MANROFFOPT=-P-i
export MANPAGER='nvim +Man!'
export MDCAT_PAGER='less --raw-control-chars --quit-if-one-screen'

export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=true
export PIPX_BIN_DIR="$HOME/bin"
export POETRY_VIRTUALENVS_IN_PROJECT=1
export POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=1

# https://github.com/tldr-pages/tldr-python-client#colors
export TLDR_COLOR_NAME='green underline'
export TLDR_COLOR_DESCRIPTION=
export TLDR_COLOR_EXAMPLE=
export TLDR_COLOR_COMMAND=blue
export TLDR_COLOR_PARAMETER=red

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse --border --prompt='choose❯ ' --pointer=❯ --marker=❯

--color=fg:#63677f,fg+:white:regular,hl:cyan,hl+:cyan,query:white:regular
--color=bg+:-1,bg+:-1,border:bright-black
--color=prompt:blue:regular,label:blue,header:blue
--color=pointer:green,info:green,spinner:cyan,marker:magenta
"