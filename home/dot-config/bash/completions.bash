# NOTE:
# Most completions are handled by the package 'bash-completion'
# and source automatically by /etc/bash.bashrc on Arch Linux.

# dotnet
if command -v dotnet > /dev/null; then
    _dotnet_bash_complete() {
        local cur="${COMP_WORDS[COMP_CWORD]}" IFS=$'\n'
        local candidates

        read -d '' -ra candidates < <(dotnet complete --position "${COMP_POINT}" "${COMP_LINE}" 2> /dev/null)

        read -d '' -ra COMPREPLY < <(compgen -W "${candidates[*]:-}" -- "$cur")
    }

    complete -f -F _dotnet_bash_complete dotnet
fi
