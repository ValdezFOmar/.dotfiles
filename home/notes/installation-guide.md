# Arch Linux: Installation guide

> [!NOTE]
> For the full documentation see the [Arch Wiki: Installation guide][arch-install-guide].

> [!TIP]
> Use the `more` command for scrolling through a large command output.

## Set the console keyboard layout and font

### Keyboard mapping

To list the available keyboard mappings do:

```sh
localectl list-keymaps
```

To set a keyboard mapping for the current session do:

```sh
loadkeys [file-name]
```

> [!TIP]
> For a persistent configuration, use a [`/etc/vconsole.conf` file](#persistent-configuration-for-the-linux-console)

For example, for a Latin American mapping do:

```sh
loadkeys la-latin1
```

### Font

Fonts at:

```sh
ls /usr/share/kbd/consolefonts/ | more
```

Some useful fonts:

- `ter-122n`
- `ter-124n`
- `ter-128n`

Setting fonts:

```console
setfont [font]
```


## Verify the boot mode

This command should return `64`, if not or the directory doesn't exists
at all, then you aren't booting in UEFI mode.

```sh
cat /sys/firmware/efi/fw_platform_size
```


## Connect to the internet

Check the network interface is enable.

```sh
ip link
```

For wireless and WLAN, make sure the card is not blocked with `rfkill`.

```sh
rfkill
rfkill unblock wlan
```

Connect to a wireless network with [`iwctl`](./connect-wifi.md#using-iwctl-live-boot).
Finally, check internet connection with:

```sh
ping archlinux.org
```

## Update the system clock

Use `timedatectl` to ensure the system clock is accurate:

```sh
timedatectl
```

## Partition the disks

Partition the disk with:

```sh
cfdisk
```

Choose a GPT label for UEFI and create the following 3 partitions

> [!IMPORTANT]
> If a EFI partition already exists, use it instead of creating a new one.

| Partition | Size       | Mount point     |
| --------- | ---------- | --------------- |
| EFI       | 300 M      | `/mnt/boot/efi` |
| swap      | +512 M     | N/A             |
| root      | ~50-100 GB | `/mnt`          |
| home      | Left space | `/mnt/home`     |

### Format partitions

Format the partitions with its proper file system

> [!IMPORTANT]
> If a EFI partition already exists, don't format it.

```sh
mkfs.ext4 /dev/[root_partition]
mkfs.ext4 /dev/[home_partition]
mkfs.fat -F 32 /dev/[EFI_partition]
mkswap /dev/[swap_partition]
```

### Mount partitions

Use the `mount` command to mount the following partitions.

```sh
mount /dev/[root_partition] /mnt
mount --mkdir /dev/[home_partition] /mnt/home
mount --mkdir /dev/[efi_system_partition] /mnt/boot/efi
```

For the swap, just turn it on.

```sh
swapon /dev/[swap_partition]
```

## Install essential packages

> [!NOTE]
> More packages can be installed after [changing root to the new system](#chroot)

Command for installing packages

```sh
pacstrap -K /mnt [pkg1] [pkg2] ...
```

List of packages to install

- `base`
- `base-devel`
- `linux`
- `linux-firmware`
- `os-prober`
- `grub`
- `efibootmgr`
- `less`
- `networkmanager`
- `neovim`
- `git`
- `terminus-font` (for setting a bigger font in Linux console)

### Drivers

Drivers for the graphics card are required to use Xorg, to see a
list of drivers:

```sh
pacman -Ss xf86-video
```

> [!NOTE]
> The Intel graphics driver may be buggy, consider using the default
> drivers instead (no installation required and more than capable).

### Microcode

A microcode package for the CPU is recommended.

- `amd-ucode` for AMD processors.
- `intel-ucode` for Intel processors.

## Configure the system

### Fstab

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot

Change root into the new system

```sh
arch-chroot /mnt
```

### Time zone

```sh
ln -sf /usr/share/zoneinfo/America/Tijuana /etc/localtime
hwclock --systohc
date
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
> Not generating the Spanish locale will cause some important
> applications to error since this locale is used for dates.

Create the `/etc/locale.conf` file and add:

```
LANG=en_US.UTF-8
```

#### Persistent configuration for the Linux console

Create the file `/etc/vconsole.conf` and write:

```
KEYMAP=la-latin1
FONT=ter-128n
XKBLAYOUT=latam
```

> [!NOTE]
> For other fonts/font sizes, select one from `pacman -Ql terminus-font`

## Network configuration

Create the `/etc/hostname` file:

```txt
[write_hostname]
```

## Users

### Root Password

Set the root password with

```sh
passwd
```

### Create user

Create new user:

```sh
useradd -m -G wheel -s /bin/bash [user_name]
```

Set password for the user:

```sh
passwd [user_name]
```

### Sudoers file

Edit the sudoers file to allow any user in the `wheel` group
to run `sudo`.

```sh
EDITOR=/usr/bin/nvim visudo
```

Uncomment the following line:

```txt
%wheel ALL=(ALL:ALL) ALL
```

## Core services

Enable the network manager so you can connect to the internet after rebooting

```sh
systemctl enable NetworkManager.service
```

Enable network time synchronization:

```sh
timedatectl set-ntp true
```

## Bootloader

### Enable `os-prober`

To be able to add OSes from other partitions to the boot entry, `os-prober` needs to be enabled.
Edit `/etc/default/grub` and uncomment the following line:

```txt
GRUB_DISABLE_OS_PROBER=false
```

### Install grub

Install and configure grub for EFI mode.

```sh
grub-install /dev/[device]
grub-mkconfig -o /boot/grub/grub.cfg
```
## Reboot

1. Exit the chroot environment with `exit`.
2. Unmount the partitions `umount -R /mnt`.
3. Type `reboot`.

## Post installation

Refer to [README](README.md) to see the instructions for adding all
the additional software after successfully installing the system.
For internet connection, use [`nmcli`](./connect-wifi.md#using-networkmanager).

[arch-install-guide]: https://wiki.archlinux.org/title/Installation_guide
