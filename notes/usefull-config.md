# General configurations


## Laptop Hardware

### Backlight / Screen Brightness

Install this package:

```sh
sudo pacman -S acpilight
```

Add the following configuration in under `/etc/udev/rules.d/90-backlight.rules`

    SUBSYSTEM=="backlight", ACTION=="add", \
      RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
      RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"


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

### Listing contents of a directory

This alias shows all the files of the current directory, listing dotfiles first.

| ~/.bashrc
|--
```sh
alias ll='ls -Alv'
```
