# Installation notes

> [!NOTE]
> Full documentation at [ArchWiki: Installation guide](https://wiki.archlinux.org/title/Installation_guide).

This document only contains notes about special cases / configuration
for my usage and is not a replacement for the archlinux documentation.
If at any point some step is not clear or something needs to be done
differently, refer back the ArchWiki guide.
Sections align with those in the ArchWiki guide.

## Contents

1. [Pre-installation](#pre-installation)
1. [Installation](#installation)
1. [Configure the system](#configure-the-system)
1. [Reboot](#reboot)
1. [Post-installation](#post-installation)

## Pre-installation

### Keyboard layout and font

For a Latin-American keyboard layout use:

```sh
loadkeys la-latin1
```

The default console font may be too small, some useful alternatives:

```sh
setfont ter-122n
setfont ter-124n
setfont ter-128n
```

### Verify the boot mode

The contents of `/sys/firmware/efi/fw_platform_size` must be `64`,
otherwise you didn't boot in UEFI mode. Reboot using UEFI mode.

### Connect to the internet

Before connecting to a network:

```sh
# Check the network interface is enable.
ip link

# Unblock the card with rfkill if using a wireless connection
rfkill
rfkill unblock wlan
```

The `iwctl` command is available, use it to connect to a wireless network:

```console
$ iwctl
[iwd]#
```

> [!TIP]
> To see all available commands type `help`.

List all available WiFi devices:

```console
[iwd]# device list
```

Initiate a scan for networks:

```console
[iwd]# station {device} scan
```

List all the networks:

```console
[iwd]# station {device} get-networks
```

Connect to a network:

```console
[iwd]# station {device} connect {SSID}
```

Test the connection:

```sh
ping ping.archlinux.org
```

### Update the system clock

Ensure the system clock is accurate by inspecting the output of:

```sh
timedatectl status
```

### Partition the disks

Partition using the `cfdisk` command, as it provides a TUI for partitioning.

```sh
cfdisk /dev/{disk-name}
```

Choose a GPT label for UEFI and create the following 4 partitions:

> [!IMPORTANT]
> If a EFI partition already exists, use it instead of creating a new one.


| Usage     | Partition               | Size       | Mount point     |
|-----------|-------------------------|------------|-----------------|
| EFI       | `/dev/{efi-partition}`  | 1 GB       | `/mnt/boot` |
| swap      | `/dev/{swap-partition}` | +512 M     | N/A             |
| root      | `/dev/{root-partition}` | ~50-100 GB | `/mnt`          |
| home      | `/dev/{home-partition}` | Left space | `/mnt/home`     |


### Format partitions

Format the partitions with the proper file system:

> [!IMPORTANT]
> If a EFI partition already exists, don't format it.

```sh
mkfs.ext4 /dev/{root-partition}
mkfs.ext4 /dev/{home-partition}
mkfs.fat -F 32 /dev/{efi-partition}
mkswap /dev/{swap-partition}
```

### Mount the file systems

Use the `mount` command to mount the partitions:

```sh
mount /dev/{root-partition} /mnt
mount --mkdir /dev/{efi-partition} /mnt/boot
mount --mkdir /dev/{home-partition} /mnt/home
```

For the swap, just turn it on:

```sh
swapon /dev/{swap-partition}
```

## Installation

### Install essential packages

Run `pacstrap` to install all the needed packages into the root of the
new system:

```sh
pacstrap -K /mnt {packages...}
```

> [!NOTE]
> More packages can be installed after [changing root to the new system](#chroot)

Packages required to bootstrap the system:

- `base`
- `base-devel`
- `linux`
- `linux-firmware`
- `grub`
- `os-prober`: if detection of other OSes is needed for `grub`
- `efibootmgr`
- `networkmanager`
- `neovim`
- `git`: required for `install.sh`
- `stow`: required for `install.sh`
- `terminus-font`: for setting a bigger font in the Linux console

A microcode package for the CPU is recommended.

- `amd-ucode` for AMD processors.
- `intel-ucode` for Intel processors.

Drivers for the graphics card are needed. Get a list of drivers with:

```sh
pacman -Ss xf86-video
```

> [!WARNING]
> The Intel graphics driver may be buggy, consider using the default
> drivers instead (no installation required and more than capable).

## Configure the system

Follow all the steps in [Configure the system*](https://wiki.archlinux.org/title/Installation_guide#Configure_the_system).

### Time zone

Use the timezone `America/Tijuana` located at `/usr/share/zoneinfo/America/Tijuana`
and enable network time synchronization:

```sh
timedatectl set-ntp true
timedatectl status
```

### Localization

Edit `/etc/locale.gen` and uncomment

```txt
en_US.UTF-8 UTF-8
es_MX.UTF-8 UTF-8
```

Then generate the locales:

```sh
locale-gen
```

> [!WARNING]
> Not generating the `es_MX` locale will cause some important
> applications to error since this locale is used for dates.

Create the `/etc/locale.conf` file and add:

```
LANG=en_US.UTF-8
```


### Network configuration

Edit the `/etc/hostname` file and write the host name for this machine.
Also enable the network manager systemd unit so you can connect to the
internet after rebooting:

```sh
systemctl enable NetworkManager.service
```

### Root password

Set the password for the root user

```sh
passwd
```

Edit the `sudoers` file to allow any user in the `wheel` group to run `sudo`.

```sh
EDITOR=/usr/bin/nvim visudo
```

Uncomment the following line:

```txt
%wheel ALL=(ALL:ALL) ALL
```

### Create user

Create and set the password for a new user:

```sh
useradd -m -G wheel -s /bin/bash {username}
passwd {username}
```


### Boot loader

#### Enable `os-prober`

For dual booting, `os-prober` needs to be enabled to add systems from
other partitions to the boot entry. Edit `/etc/default/grub` and
uncomment the following line:

```ini
GRUB_DISABLE_OS_PROBER=false
```

#### Install grub

Install and configure grub for EFI mode.

> [!NOTE]
> `{device}` is a *device* name, **NOT** a *partition*

```sh
grub-install /dev/{device}
grub-mkconfig -o /boot/grub/grub.cfg
```

### Console configuration

To configure a persistent font for the Linux console, edit
`/etc/vconsole.conf` and add:

```sh
FONT=font
```

Where `font` is the name of a font provided by the `terminus-font`
package (e.g. the one set in [Keyboard layout and font](#keyboard-layout-and-font)).

> [!NOTE]
> For other fonts/font sizes, select one from `pacman -Ql terminus-font`

## Reboot

1. Exit the `chroot` environment with `exit`.
2. Unmount the partitions `umount -R /mnt`.
3. Type `reboot`.

## Post-installation

Refer to [README](README.md) to see the instructions for adding all
the additional software after successfully installing the system.

### Pacman configuration

Edit `/etc/pacman.conf` and uncomment:

- `Color` option for colored output
- `VerbosePkgLists` option to show each package on a separate line and
  with more details.

To enable colored output, edit and uncomment
the `Color` option.

### Connect to the internet with `nmcli`

List nearby WiFi networks:

```sh
nmcli device wifi list
```

Connect to a WiFi network:

```sh
nmcli device wifi connect {SSID} password {password}
```

### Configure power button behaviour

For a laptop, changing the behaviour of the power button can prevent
with accidentally shutting down the computer.
Edit the file `/etc/systemd/logind.conf` and change the configuration
for the power button:

```ini
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff
```

Then, to apply the changes, run:

```sh
sudo systemctl kill --signal HUP systemd-logind
```

### Permissions for brightness devices

Create `/etc/udev/rules.d/90-backlight.rules` and add the following
configuration to be able to modify device brightness:

> [!TIP]
> `:TSInstall udev`

```udev
SUBSYSTEM=="backlight", ACTION=="add", \
  RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", \
  RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

Then add the user to the `video` group:

```sh
usermod --apend --groups video "$(whoami)"
```
