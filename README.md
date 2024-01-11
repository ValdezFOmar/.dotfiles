# Dotfiles

Dotfiles for my Arch linux distro.

> For Additional installation info, check the [installation guide](./notes/installation-guide.md).

## Setup

Clone the repository.

```sh
git clone https://github.com/ValdezFOmar/.dotfiles.git && cd .dotfiles/
```

Install the system configurations:

```sh
./install/system-config.sh
```

Install the user configurations:

```sh
./install/user-config.py --all
```

> NOTE: This will install all the config files. To see more options use the flag `--help`.


## Greeter

To set up the session greeter for LightDM, edit the following line in `/etc/lightdm/lightdm.conf`:

```
[Seat:*]
...
greeter-session=lightdm-slick-greeter
...
```
