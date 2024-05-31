# shellcheck source=/dev/null

#
#   Aliases
#

# Space for expanding command aliases when using sudo
#alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -AvF'
alias ll='ls -Alvh'

alias cp='cp -i '
alias mv='mv -i '
alias rm='rm -I '
alias md='mkdir '

alias cd..='cd ..'
alias vim='nvim'
alias kssh='kitten ssh '
alias neofetch='fastfetch'
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

function cl()
{
    if [[ -z "$1" ]]; then
        echo "cl: No directory provided"
        return 1
    fi
    la -- "$1" && cd -- "$1" || return 1
}

function mcd()
{
    if [[ -z "$1" ]]; then
        echo "mcd: No name provided"
        return 1
    fi
    mkdir -p -- "$1" && cd -P -- "$1" || return 1
}

# pretty print paths in $PATH
function paths()
{
    local bin_paths
    IFS=':' read -ra bin_paths <<< "$PATH"
    for bin_path in "${bin_paths[@]}"; do
        echo "$bin_path"
    done
}


# activate virtual env
function activate()
{
    local venv_name="${1:=.venv}"

    if [[ ! -d "./$venv_name" ]]; then
        >&2 echo "==> There's no '$venv_name' directory"
        return 1
    fi

    if [[ ! -f "./$venv_name/bin/activate" ]]; then
        >&2 echo "==> There's no file to source"
        return 1
    fi

    source "./$venv_name/bin/activate"
}

# Create virtual env
venv()
{
    local venv_name=".venv"

    if [[ -d $venv_name ]]; then
        echo "===> '$venv_name' already exists"
        return 1
    fi

    if ! pyenv local &> /dev/null; then
        echo "===> No local python version detected"
        return 1
    fi

    echo "Creating virtual enviroment..."
    python -m venv "./$venv_name" --prompt "\[$(tput setaf 2)\]$venv_name\[$(tput sgr0)\]"
    activate "$venv_name"
    pip -V

    if [[ -f ./requirements.txt ]]; then
        read -p "Install from 'requirements.txt' file? (Y/n) " -r answer
        if [[ -z $answer || $answer = "y" || $answer = "yes" ]]; then
            pip install -r ./requirements.txt
        fi
    fi
}


# vim: set ft=sh:
