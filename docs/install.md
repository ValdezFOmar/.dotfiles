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

### Create partitions

Create the partitions using the `cfdisk` command, as it provides a TUI
for partitioning.

```sh
cfdisk /dev/{disk-name}
```

Choose a GPT label for UEFI and create the following 4 partitions:

> [!WARNING]
> If a EFI partition already exists, use it instead of creating a new one.

| Usage | Partition               | Partition type   | Size    | Mount point  |
|-------|-------------------------|------------------|---------|--------------|
| ESP   | `/dev/{efi-partition}`  | EFI system       | 1-4 GB  | `/mnt/boot`  |
| root  | `/dev/{root-partition}` | Linux filesystem | 100+ GB | `/mnt`       |


### Format partitions

Format the partitions with the proper file system:

> [!WARNING]
> If a EFI partition already exists, don't format it.

```sh
mkfs.ext4 /dev/{root-partition}
mkfs.fat -F 32 /dev/{efi-partition}
```

### Mount partitions

Use the `mount` command to mount the partitions:

```sh
mount /dev/{root-partition} /mnt
mount --mkdir /dev/{efi-partition} /mnt/boot
```

### Swap file

Create a swap file, as it is more flexible than using a swap partition:

```sh
mkswap -U clear --size 4G --file /mnt/swapfile
swapon /mnt/swapfile
```

## Installation

### Install essential packages

Run `pacstrap` to install all the needed packages into the root of the
new system:

```sh
pacstrap -K /mnt {packages...}
```

> [!NOTE]
> More packages can be installed after [changing root](#chroot) to the new system.

Packages required to bootstrap the system:

- `base`
- `base-devel`
- `linux`
- `linux-firmware`
- `efibootmgr`
- `networkmanager`
- `neovim`
- `git`: required for `install.sh`
- `stow`: required for `install.sh`
- `terminus-font`: for setting a bigger font in the Linux console

A microcode package for the CPU is recommended.

- `amd-ucode` for AMD processors.
- `intel-ucode` for Intel processors.

For GPU drivers, consult the relevant [ArchWiki page](https://wiki.archlinux.org/title/Graphics_processing_unit).

> [!IMPORTANT]
> DDX drivers (package name starting with *xf86-video*) are *NOT* needed
> for Wayland and might cause issues with some GUIs (e.g. Kitty).

## Configure the system

### Fstab

For auto-mounting the file system on startup:

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot

Change root to the new system to directly interact with it:

```sh
arch-chroot /mnt
```

### Time zone

Use the timezone `America/Tijuana` located at `/usr/share/zoneinfo/America/Tijuana`
and enable network time synchronization:

```sh
ln -sf /usr/share/zoneinfo/America/Tijuana /etc/localtime
hwclock --systohc
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
useradd --create-home --group wheel {username}
passwd {username}
```

### Boot loader

> [!NOTE]
> See [`systemd-boot` wiki](https://wiki.archlinux.org/title/Systemd-boot).

Install `systemd-boot` with `bootctl install` and it will automatically
found the EFI system partition at `/boot`. Configure the boot loader at
`/boot/loader/loader.conf`:

```conf
default arch.conf
timeout 10
auto-firmware on
auto-poweroff on
```

Since `systemd-boot` doesn't automatically create menu entries for
booting Arch Linux, entries must be manually added as files under
`/boot/loader/entries`.

> [!IMPORTANT]
> Replace `{FS-UUID}` with the file system UUID of the root partition.
> To get the UUID, run `lsblk -f`.

Default entry at `/boot/loader/entries/arch.conf`:

```conf
### Default entry for Arch Linux ###
# Printing to console is slow, avoid that for a faster boot
# https://wiki.archlinux.org/title/Improving_performance/Boot_process#Less_output_during_boot
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID={FS-UUID} rw quiet loglevel=3 systemd.show_status=auto rd.udev.log_level=3
```

Fallback entry at `/boot/loader/entries/arch-fallback.conf`:

```conf
title   Arch Linux (fallback initramfs)
linux   /vmlinuz-linux
initrd  /initramfs-linux-fallback.img
options root=UUID={FS-UUID} rw
```

> [!NOTE]
> The Arch Linux ISO can be used as a rescue system.
> See [Archiso on ESP](https://wiki.archlinux.org/title/Systemd-boot#Archiso_on_ESP).


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
  - Use `fuser -v -m /mnt` to check for busy partitions.
3. Type `reboot`.

## Post-installation

Refer to [README](/README.md) to see the instructions for adding all
the additional software after successfully installing the system.

### Pacman configuration

Edit `/etc/pacman.conf` and uncomment:

- `Color` option for colored output
- `VerbosePkgLists` option to show each package on a separate line and
  with more details.

### SSH configuration

Create and edit `~/.ssh/config`. The following configuration helps to
avoid repeatedly inputting the passphrase for the current session
(specially useful for `git` operations):

```sshconfig
Host *
    AddKeysToAgent yes
```

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

> [!IMPORTANT]
> There's no need to add udev rules if DBus is used to change the
> monitors brightness (`brightnessctl` does this by default).

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
