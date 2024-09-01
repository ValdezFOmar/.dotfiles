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

alias cd..='cd ..'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias md='mkdir --parents'

alias vim='nvim'
alias ts='tree-sitter'
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
    local bin_paths bin_path
    IFS=':' read -ra bin_paths <<< "$PATH"
    for bin_path in "${bin_paths[@]}"; do
        echo "$bin_path"
    done
}

# activate virtual env
function activate()
{
    local venv_name="${1:-.venv}"  # Assigning with := is not allowed
    source "./$venv_name/bin/activate"
}

function venv()
{
    local answer files file
    local venv_name="${1:-.venv}"

    mkvenv "$venv_name" || return $?
    activate "$venv_name" || return $?

    mapfile -d $'\0' -t files < <(find . -type f -name '*requirements*.txt' -print0)

    for file in "${files[@]}"; do
        read -p "Install from '$file' file? [Y/n] " -r answer
        if (shopt -s nocasematch; [[ $answer =~ ^(y(es)?)?$ ]]); then
            pip install --requirement "$file"
        fi
    done
}
