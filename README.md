# Dotfiles

Dotfiles for my Arch linux distro.

## Setup

> For Additional installation info, check [notes](./notes/installation-guide.md).

### Clone and source setup script

First clone the repository.

```sh
git clone https://github.com/ValdezFOmar/arch-dotfiles.git ~/.dotfiles
```

Source the install script.
```sh
. ~/.dotfiles/setup
```

### Enable services

This services need to be enable so they can run at startup:

```sh
systemctl enable lightdm.service
systemctl enable NetworkManager.service
```


## Greeter

To set up the session greeter for LightDM, edit
`/etc/lightdm/lightdm.conf`:

    [Seat:*]
    ...
    greeter-session=lightdm-slick-greeter
    ...


### Config greeter

Configurations for the greeter can be found under
`/etc/lightdm/`. Look for:

    [name]-greeter.conf
