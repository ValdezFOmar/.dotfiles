#!/usr/bin/env bash

# This script contains useful or commonly used functionalities for git.
# Primarily used with git aliases

# Exit on errors
set -o errexit
set -o nounset
set -o pipefail

die() {
    # Bash parameter substitution
    local prog="${BASH_SOURCE[0]##*/}"
    >&2 echo "${prog}:" "$@"
    exit 1
}

recover-file() {
    local commit file=$1

    [[ -e $file ]] && die "File '$file' exists"

    commit=$(git rev-list -n 1 HEAD -- "$file")
    [[ ! $commit ]] && die "No commit found for '$file'"

    # get the file from the commit prior to its deletion
    git checkout "${commit}~1" -- "$file"
}

bat-diff() {
    declare -a files
    mapfile -t files < <(git diff --name-only)

    if [[ ${#files[@]} -ne 0 ]]; then
        bat --diff "${files[@]}"
    else
        echo 'No files to show'
    fi
}

intersection-diff() {
    # Show the diff for files that are staged and also have unstaged
    # modifications. Useful for reviewing changes made by pre-commit
    declare -a files

    mapfile -t files < <(comm -12 \
        <(git diff --name-only | sort) \
        <(git diff --name-only --cached | sort))

    if [[ ${#files[@]} -ne 0 ]]; then
        bat --diff "${files[@]}"
    else
        echo 'No files to show'
    fi
}

restage-files() {
    # Similar to `intersection-diff`, but stages the files instead
    declare -a files

    mapfile -t files < <(comm -12 \
        <(git diff --name-only | sort) \
        <(git diff --name-only --cached | sort))

    if [[ ${#files[@]} -ne 0 ]]; then
        git add "${files[@]}"
    else
        echo 'No files to restage'
    fi
}

main() {
    case "$1" in
        --recover-file)
            [[ ! $2 ]] && die 'No file provided'
            recover-file "$2"
            ;;
        --bat-diff) bat-diff ;;
        --intersection-diff) intersection-diff ;;
        --restage-files) restage-files ;;
        *) die "Unsupported option '$1'" ;;
    esac
}

main "$@"
