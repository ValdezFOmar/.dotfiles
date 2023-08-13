# Arch Linux: Installation guide

> For the full documentation see the [Arch Wiki: Installation guide](https://wiki.archlinux.org/title/Installation_guide).

> Use the `less` conmmand for scrolling through a large command output.

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

This command should return `64`, if not or the directory doesn't exists at all, then you aren't booting in UEFI mode.

    cat /sys/firmware/efi/fw_platform_size


## Network

Check internet connection with

    ping archlinux.org


## System clock

    timedatectl set-ntp true
    timedatectl status

---
```sh
# Region/City for timezone
# /urs/share/zoneinfo/America/Tijuana

# When using grub-install, use this flag to locale the directory
# where the EFI partition is mounted
--efi-directory=path/to/dir

# For using man pages
pacman -S man-db

umount -R /mnt
```

```sh
# For a bigger font
sudo pacman -S terminus-font
setfont ter-132b
```

---

Before building packages, a meta package needs to be installed
```sh
sudo pacman -S base-devel
sudo pacman -S networkmanager
```