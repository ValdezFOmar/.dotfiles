# shellcheck source=/dev/null

#
#   Aliases
#

# Space for expanding command aliases when using sudo
alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -AvF'
alias ll='ls -Alvh'

alias cd..='cd ..'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias md='mkdir --parents'

alias vim='nvim'
alias ts='tree-sitter'
alias kssh='kitten ssh'
alias ff='fastfetch'
alias tree='tree --dirsfirst -C'
alias gitree='tree -a --prune --gitignore -I .git/'
alias mdcat='mdcat --columns 80'
alias mdless='mdless --columns 80'

alias py='python'
alias pip='pip --require-virtualenv'
alias console-csharp='dotnet new console --use-program-main'

alias cal='cal --monday'
alias month='cal --one'
alias calendar='cal --year'
alias disk='df -h --type=ext4'
alias space='du --summarize --total --human-readable'

#
#   Functions
#

function cl() {
    if [[ -z $1 ]]; then
        echo "cl: No directory provided"
        return 1
    fi
    la -- "$1" && cd -- "$1" || return
}

function mcd() {
    if [[ -z $1 ]]; then
        echo "mcd: No name provided"
        return 1
    fi
    mkdir --parents -- "$1" && cd -P -- "$1" || return
}

# pretty print paths in $PATH
function paths() {
    tr ':' '\n' <<< "$PATH"
}

# Lazy load pyenv.
# It takes a considerable amount of time to initialise and it is not always used.
function pyenv() {
    unset -f pyenv
    if command -v pyenv > /dev/null; then
        eval "$(pyenv init - bash)"
    elif [[ -n $PYENV_ROOT && -x $PYENV_ROOT/bin/pyenv ]]; then
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init - bash)"
    else
        >&2 echo 'error: command "pyenv" not found'
        return 1
    fi
    pyenv "$@"
}

# activate virtual env
function activate() {
    local venv_name="${1:-.venv}" # Assigning with := is not allowed
    source "./$venv_name/bin/activate"
}

function venv() {
    local answer file
    local venv_name="${1:-.venv}"

    mkvenv "$venv_name" || return
    activate "$venv_name" || return

    for file in requirements.txt dev-requirements.txt requirements-dev.txt; do
        [[ -f $file ]] || continue
        read -p "Install from '$file' file? [Y/n] " -r answer
        if [[ -z $answer || $answer =~ ^y(es)?$ ]]; then
            pip install --requirement "$file"
        fi
    done
}
