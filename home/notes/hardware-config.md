# Hardware Configuration

> [!TIP]
> After every kernel update (`linux` package) reboot the system so the
> new kernel modules for hardware are loaded (e.g. USB drives)


## CPU Frequency Scaling

See the archlinux wiki for controlling the CPU [Frequency][cpu-frequency].
Use `cpupower` to do all the configurations.

Check the [Power Governors][power-governors] section for different power modes.

> [!TIP]
> A [script for controlling the CPU frequency][cpu-frequency-script]
> is provided, but needs needs permission to run `cpupower`.

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

Edit the file `/etc/systemd/logind.conf` and add the following
configuration:

```
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff
```

Then, to apply the changes, run:

```sh
sudo systemctl kill -s HUP systemd-logind
```


## Backlight / Screen Brightness

Use the package `acpilight`, it provides the command `xbacklight`. Add
the following configuration under `/etc/udev/rules.d/90-backlight.rules`:

> [!TIP]
> `:TSInstall udev`

```udev
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

Then add the user to the `video` group:

```sh
usermod --apend --groups video $(whoami)
```

[cpu-frequency]: https://wiki.archlinux.org/title/CPU_frequency_scaling
[power-governors]: https://wiki.archlinux.org/title/CPU_frequency_scaling#Scaling_governors
[cpu-frequency-script]: ../bin/frequencymenu
