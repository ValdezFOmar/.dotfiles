# General configurations


## Laptop Hardware

### CPU Frequency Scaling

See the archlinux wiki for controlling the CPU [Frequency](https://wiki.archlinux.org/title/CPU_frequency_scaling).
Use `cpupower` to do all the configurations.

Check the [Power Governors](https://wiki.archlinux.org/title/CPU_frequency_scaling#Scaling_governors)
for diferent power modes.

### Run `cpupower` without password prompt

Edit `/etc/sudoers` with the `visudo` command:

```sh
sudo visudo /etc/sudoers
```

Add the following lines at the end of the file:

```
user_name ALL=(ALL) NOPASSWD: /usr/bin/cpupower frequency-set*
```

### Shutdown button suspends the computer

Edit the file `/etc/systemd/logind.conf` and add the following configuration:

    HandlePowerKey=suspend
    HandlePowerKeyLongPress=poweroff

Then, to apply the changes, run:

    sudo systemctl kill -s HUP systemd-logind


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
