# Dotfiles

Dotfiles and installation scripts for my Arch Linux setup.

![Desktop](./desktop_screenshot.png)

## Setup

Clone the repository.

```sh
git clone https://github.com/ValdezFOmar/.dotfiles.git && cd .dotfiles/
```

Install the system configurations:

```sh
./install/system-config.py --all
```

Install the user configurations:

```sh
./install/user-config.py --all
```

> NOTE: This will install all the config files. To see more options use the flag `--help`.

For Additional installation info:
1. [Arch Linux installation guide](/notes/installation-guide.md).
2. [Wi-Fi Connection](/notes/connect-wifi.md)
3. [GUI setup](/notes/gui-config.md)
