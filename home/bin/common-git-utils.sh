#!/usr/bin/env bash

# This script contains useful or commonly used functionalities for git.
# Primarily used with git aliases

# Exit on errors
set -o errexit
set -o nounset
set -o pipefail

readonly program=${0##*/}

function die() {
    >&2 echo "$program: error: $*"
    exit 1
}

function intersection-diff() {
    # Show the diff for files that are staged and also have unstaged
    # modifications. Useful for reviewing changes made by pre-commit
    declare -a files
    mapfile -t files < <(comm -12 <(git diff --name-only | sort) <(git diff --name-only --cached | sort))

    if [[ ${#files[@]} -ne 0 ]]; then
        git diff "${files[@]}"
    else
        echo "$program: no files to show"
    fi
}

function restage-files() {
    # Similar to `intersection-diff`, but stages the files instead
    declare -a files
    mapfile -t files < <(comm -12 <(git diff --name-only | sort) <(git diff --name-only --cached | sort))

    if [[ ${#files[@]} -ne 0 ]]; then
        git add "${files[@]}"
    else
        echo "$program: no files to restage"
    fi
}

function main() {
    if [[ $# -eq 0 ]]; then
        die 'no option provided'
    elif [[ $# -eq 1 ]]; then
        case "$1" in
            --intersection-diff) intersection-diff ;;
            --restage-files) restage-files ;;
            *) die "unsupported option: $1" ;;
        esac
    else
        die 'too many options provided'
    fi
}

main "$@"
