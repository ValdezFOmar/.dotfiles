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
    local venv_name="${1:-.venv}"  # Assigning with := is not allowed

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

# Depends on:
#   - pyenv
#   - virtualenv
#   - fd
#   - fzf
function venv()
{
    local venv_name=".venv" error green normal answer version

    error="$(tput setaf 1)"
    green="$(tput setaf 2)"
    normal="$(tput sgr0)"

    if [[ -d $venv_name ]]; then
        >&2 echo "${error}==> '$venv_name' already exists${normal}"
        return 1
    fi

    if ! command -v pyenv > /dev/null; then
        echo "${error}==> pyenv not found${normal}"
        read -p "Use system $(python --version) instead? [y/N] " -r answer
        if (shopt -s nocasematch; [[ ! $answer =~ ^y(es)?$ ]]); then
            return 1
        fi
        version=$(python -c 'import sys; sys.stdout.write(".".join(map(str, sys.version_info[:3])))')
    elif ! pyenv local &> /dev/null; then
        if version=$(pyenv versions --bare | fzf --height='~100%' --no-info --disabled --tac); then
            pyenv local "$version"
        else
            return $?
        fi
    else
        version=$(pyenv local)
    fi

    echo "${green}::${normal} Creating virtual enviroment..."
    virtualenv --python "$version" "./$venv_name" \
                   --prompt "\[$green\]$venv_name\[$normal\]" \
                   --copies
    activate "$venv_name" || return 1

    for file in $(fd --glob '*requirements*.txt'); do
        read -p "Install from '$file' file? [Y/n] " -r answer
        if (shopt -s nocasematch; [[ $answer =~ ^(y(es)?)?$ ]]); then
            pip install --requirement "$file"
        fi
    done
}


# vim: set ft=bash:
