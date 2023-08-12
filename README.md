# Dotfiles

Dotfiles for my arch linux distro

## Install

First clone the repository.

```sh
git clone https://github.com/ValdezFOmar/arch-dotfiles.git ~/.dotfiles
```

Source the install script.
```sh
. ~/.dotfiles/setup
```

## Enable services

This services need to be enable sot they can run at startup

```sh
systemctl enable lightdm.service
systemctl enable NetworkManager.service
```

## Greeter

To set up the session greeter for LightDM, edit 
`/etc/lightdm/lightdm.conf` :

    [Seat:*]
    ...
    greeter-session=lightdm-slick-greeter
    ...


### Config greeter

Configurations for the greeter can be found under 
`/etc/lightdm/`. Look for:

    [name]-greeter.conf