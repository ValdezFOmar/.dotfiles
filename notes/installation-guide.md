# Arch Linux: Installation guide

> For the full documentation see the [Arch Wiki: Installation guide](https://wiki.archlinux.org/title/Installation_guide).

> Use the `less` command for scrolling through a large command output.

## Set the console keyboard layout and font

### Keymap

For a latin-american keyboard layout:

    /usr/share/kbd/keymaps/i386/qwerty/la-latin1.map.gz

To set it as the keyboard layout:

```sh
loadkeys la-latin1
```

### Font

Fonts at:

```sh
ls /usr/share/kbd/consolefonts/

# Some useful fonts:
# ...
# ter-122n
# ter-124n
# ter-128n
# ...
```

Setting fonts:

    setfont [font]


## Verify the boot mode

This command should return `64`, if not or the directory doesn't exists at all,
then you aren't booting in UEFI mode.

    cat /sys/firmware/efi/fw_platform_size


## Connect to the internet

Check the network interface is enable.

    ip link

For wireless and WLAN, make sure the card is not blocked with `rfkill`.

    rfkill
    rfkill unblock wlan

Connect to a wireless network with [`iwctl`](./connect-wifi.md#using-iwctl-live-boot).

Finally, check internet connection with:

    ping archlinux.org


## Update the system clock

Use `timedatectl` to ensure the system clock is accurate:

    timedatectl

## Partition the disks

Partition the disk with:

    cfdisk

Choose a GPT label for UEFI and create the following 3 partitions

> **NOTE**: If a EFI partition already exists, use it instead of creating a new one.

| Partition | Size       | mount         |
| --------- | ---------- | ------------- |
| EFI       | 300 M      | /mnt/boot/efi |
| swap      | +512 M     | [SWAP]        |
| root      | ~50-100 GB | /mnt          |
| home      | Left space | /mnt/home     |

### Format partitions

Format the partitions with its proper file system

> **NOTE**: If a EFI partition already exists, don't format it.

    mkfs.ext4 /dev/[root_partition]
    mkfs.ext4 /dev/[home_partition]
    mkfs.fat -F 32 /dev/[EFI_partition]
    mkswap /dev/[swap_partition]

### Mount partitions

Use the `mount` command to mount the following partitions.

    mount /dev/[root_partition] /mnt
    mount --mkdir /dev/[home_partition] /mnt/home
    mount --mkdir /dev/[efi_system_partition] /mnt/boot/efi

For the swap, just turn it on.

    swapon /dev/[swap_partition]


## Install essential packages

Command for installing packages

    pacstrap -K /mnt [pkg_1] [pkg_2] ...

List of packages to install

- `base`
- `base-devel`
- `linux`
- `linux-firmware`
- `os-prober`
- `grub`
- `efibootmgr`
- `networkmanager`
- `nvim`
- `git`

### Drivers

Drivers for the graphics card are required to use Xorg, to see a list of drivers:

    pacman -Ss xf86-video

### Microcode

A microcode package for the CPU is required.

- `amd-ucode` for AMD processors.
- `intel-ucode` for Intel processors.

## Configure the system

### Fstab

    genfstab -U /mnt >> /mnt/etc/fstab

### Chroot

Change root into the new system

    arch-chroot /mnt

### Time zone

    ln -sf /usr/share/zoneinfo/America/Tijuana /etc/localtime
    hwclock --systohc
    date

### Localization

Edit `/etc/locale.gen` and uncomment `en_US.UTF-8 UTF-8`, then generate the locales:

    locale-gen

Create the `/etc/locale.conf` file and add:

    LANG=en_US.UTF-8

Also create `/etc/vconsole.conf` and add:

    KEYMAP=la-latin1
    FONT=ter-128n

## Network configuration

Create the `/etc/hostname` file:

    [write_hostname]

## Users

### Root Password

Set the root password with

    passwd

### Create user

Create new user:

    useradd -m -G wheel -s /bin/bash [user_name]

Set password for the user:

    passwd [user_name]

### Sudoers file

Edit the sudoers file so any user of the group `wheel` would be able to run `sudo` commands.

    EDITOR=nvim visudo

Uncomment the following line:

    %wheel ALL=(ALL) ALL

## Core services

Enable the network manager so you can connect to the internet after rebooting

    systemctl enable NetworkManager.service

## Bootloader

Install and configure grub for EFI mode.

    grub-install /dev/[device]
    grub-mkconfig -o /boot/grub/grub.cfg

## Reboot

1. Exit the chroot environment with `exit`.
2. Unmount the partitions `umount -R /mnt`.
3. Type `reboot`.

## Post installation

Refer to [README](../README.md) to see the instructions for adding all the additional software after
successfully installing the system.

For internet connection, refer to [how to connect to WiFi with NetworkManager](./connect-wifi.md#using-networkmanager).
