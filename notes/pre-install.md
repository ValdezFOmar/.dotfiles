# Pre-Installation configurations

## Bootloader

Install and configure grub for EFI mode.

    pacman -S grub efibootmgr
    grub-install /dev/[device]
    grub-mkconfig -o /boot/grub/grub.cfg

## Drivers

Drivers for the graphics card are required to use Xorg, to see a list of drivers:

    pacman -Ss xf86-video

## Microcode

A microcode package for the CPU is required.

- `amd-ucode` for AMD processors,
- `intel-ucode` for Intel processors.