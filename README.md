# arch-dotfiles

Dotfiles for my arch linux distro

## Install

```
. ~/.dotfiles/install/install
```

## Enable services

This services need to run at boot

```sh
systemctl enable lightdm.service
systemctl enable NetworkManager.service
```

## Greeter

To set up the session greeter gor LightDM:

    /etc/lightdm/lightdm.conf

```
[Seat:*]
...
greeter-session=lightdm-[name]-greeter
...
```

### Config greeter

Configurations for the greeter can be found under:

    /etc/lightdm/

Look for:

    [name]-greeter.conf