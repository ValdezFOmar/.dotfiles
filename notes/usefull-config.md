# General configurations

## Terminal

### Generate a list of installed packages

    pacman -Qet

### Custom Prompt

| ~/.bashrc
|--
```sh
PS1='\u@\h \w> '
```

> Check [Arch Wiki: Custom prompt](https://wiki.archlinux.org/title/Bash/Prompt_customization)


### Autocd when typing a path

| ~/.bashrc
|--
```sh
shopt -s autcd
```

## Listing contents of a directory

This alias shows all the files of the current directory, listing dotfiles first.

| ~/.bashrc
|--
```sh
alias ll='ls -Alv'
```
