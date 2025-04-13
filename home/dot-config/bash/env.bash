# shellcheck disable=SC2155

# Environmental variables for CLI only programs.
# UI and other environmental variables are defined in ~/uwsm/env
# so they are available during the session and not only in the shell

function history-path() {
    local directory="$XDG_STATE_HOME/$1"
    [[ -d $directory ]] || mkdir --parents "$directory"
    printf '%s' "$directory/history"
}

# NOTE: This should be moved to a Termux dedicated file
# Termux doesn't set XDG_RUNTIME_DIR
if [[ -z $XDG_RUNTIME_DIR && -w $TMPDIR ]]; then
    XDG_RUNTIME_DIR="$TMPDIR/$UID"
    mkdir --mode=700 "$XDG_RUNTIME_DIR"
    export XDG_RUNTIME_DIR
fi

# bash(1) "Shell Variables" section
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export HISTCONTROL=ignorespace,ignoredups,erasedups
export HISTIGNORE='history*:ls .*:la .*:ll .*:cd .*:cd:exit:clear'
export HISTFILE=$(history-path bash)

# python 3.13+ only
export PYTHON_HISTORY=$(history-path python)
export NODE_REPL_HISTORY=$(history-path node)

# Build a static library when installing python versions (e.g. pyenv)
export PYTHON_CONFIGURE_OPTS=--disable-shared

# Destination for resources installed with pyenv
export PYENV_ROOT="$XDG_STATE_HOME/pyenv"

# Use italics instead of underlines
export MANROFFOPT=-P-i
export MANPAGER='nvim +Man!'
export MDCAT_PAGER='less --raw-control-chars --quit-if-one-screen'

export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=true
export PIPX_BIN_DIR=$XDG_BIN_HOME
export POETRY_VIRTUALENVS_IN_PROJECT=1
export POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=1

# https://github.com/tldr-pages/tldr-python-client#colors
export TLDR_COLOR_NAME='green underline'
export TLDR_COLOR_DESCRIPTION=
export TLDR_COLOR_EXAMPLE=
export TLDR_COLOR_COMMAND=blue
export TLDR_COLOR_PARAMETER=red

# bat
export BAT_THEME=TwoDark

# fzf
export FZF_DEFAULT_OPTS="
--layout=reverse --border --prompt='choose❯ ' --pointer=❯ --marker=❯

--color=fg:#63677f,current-fg:white,selected-fg:magenta:bold,preview-fg:white
--color=bg:-1,current-bg:-1,border:bright-black
--color=hl:cyan,current-hl:cyan,query:white:regular
--color=prompt:blue:regular,label:blue,header:blue
--color=pointer:green,info:green,spinner:cyan,marker:magenta
"

unset -f history-path
