# Dotfiles

Dotfiles and installation scripts for my Arch Linux setup.

![Desktop](./desktop_screenshot.png)

## Setup

Dependencies:

- `git`
- `stow`

On a fresh installation of Arch, clone this repository.

```sh
git clone https://github.com/ValdezFOmar/.dotfiles.git ~/.dotfiles
```

Then run the installation script for user and system configurations, in
that order:

```sh
cd ~/.dotfiles/
./install.sh
sudo ./etc/install.sh
```

> [!WARNING]
> This will download and install multiple packages, create directories
> on `~/`, symlink user configuration files, replace some system
> configuration files and enable some services.
>
> For only installing user configurationfiles run:
>
> ```bash
> cd ~/.dotfiles && stow home
> ```

## Extra

For Additional installation info:

1. [Arch Linux installation guide](home/notes/installation-guide.md).
2. [Wi-Fi Connection](home/notes/connect-wifi.md)
3. [GUI setup](home/notes/gui-config.md)
