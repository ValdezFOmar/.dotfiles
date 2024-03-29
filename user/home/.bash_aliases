# shellcheck source=/dev/null

#
#   Aliases
#

# Space for expanding command aliases when using sudo
#alias sudo='sudo '

alias grep='grep --color=auto'
alias ls='ls --color=auto --group-directories-first'
alias la='ls -AvF'
alias ll='ls -AlvGh'

alias cp='cp -i '
alias mv='mv -i '
alias rm='rm -I '
alias md='mkdir '

alias cd..='cd ..'
alias vim='nvim '
alias kssh='kitten ssh '
alias tree='tree --dirsfirst -C'
alias gitree='tree -a --prune --gitignore -I .git/'

alias py='python'
alias pip='pip --require-virtualenv'

alias cal='cal --monday'
alias month='cal --one'
alias calendar='cal --year'
alias disk='df -H --type=ext4'


#
#   Functions
#

cl()
{
    if [[ -z "$1" ]]; then
        echo "cl: No directory provided"
        return 1
    fi
    la -- "$1" && cd -- "$1" || return 1
}

mcd()
{
    if [[ -z "$1" ]]; then
        echo "mcd: No name provided"
        return 1
    fi
    mkdir -p -- "$1" && cd -P -- "$1" || return 1
}

gitdiff()
{
    # shellcheck disable=SC2046
    # word splitting is useful here so `bat` can read each individual file
    bat --diff $(git diff --name-only)
}

# activate virtual env
activate()
{
    local venv_name="${1:-.venv}"

    if [[ ! -d "./$venv_name" ]]; then
        echo "===> There's no '$venv_name' directory"
        return 1
    fi

    if [[ ! -f "./$venv_name/bin/activate" ]]; then
        echo "===> There's no file to source"
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
