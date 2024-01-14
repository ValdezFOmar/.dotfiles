# Hardware Configuration


## CPU Frequency Scaling

See the archlinux wiki for controlling the CPU [Frequency](https://wiki.archlinux.org/title/CPU_frequency_scaling).
Use `cpupower` to do all the configurations.

Check the [Power Governors](https://wiki.archlinux.org/title/CPU_frequency_scaling#Scaling_governors)
for diferent power modes.

> A [script for controlling the CPU frequency](../user/.local/bin/frequencymenu) is provided, but needs
> needs permission to [run `cpupower`](#run-cpupower-without-password-prompt).


## Run `cpupower` without password prompt

Edit `/etc/sudoers` with the `visudo` command:

```sh
sudo visudo /etc/sudoers
```

Add the following lines at the end of the file:

```
user_name ALL=(ALL) NOPASSWD: /usr/bin/cpupower frequency-set*
```


## Shutdown button suspends the computer

Edit the file `/etc/systemd/logind.conf` and add the following configuration:

```
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff
```

Then, to apply the changes, run:

```sh
sudo systemctl kill -s HUP systemd-logind
```


## Backlight / Screen Brightness

Use the package `acpilight`, provides the command `xbacklight`. Add the following configuration
under `/etc/udev/rules.d/90-backlight.rules`:

```
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```
