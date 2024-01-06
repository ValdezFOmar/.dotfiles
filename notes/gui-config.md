# Graphical User Interface

Steps for configuring a GUI

Table of contents

- [KDE Plasma](#kde-plasma)
-

# KDE Plasma

## 1. Install X11

> Resources<br>
> [X11 Keyboard config](https://wiki.archlinux.org/title/Xorg/Keyboard_configuration)

installation
```sh
sudo pacman -S xorg
```

### Temporal X11 keyboard configuration
To see a full list of keyboard models, layouts, variants and options for X11,
along with a short description, do the following:

```sh
cat /usr/share/X11/xkb/rules/base.lst | less
```

To set up the configuration, use the following commands:

```sh
setxkbmap -model xkb_model
setxkbmap -layout xkb_layout
setxkbmap -variant xkb_variant
setxkbmap -option xkb_options
```

> For latin american keyboard layout use: `setxkbmap -layout latam`.

### Persistent keyboard configuration

For a persisten keyboard layout configuration use this command
instead (reboot to see changes):

    localectl set-x11-keymap skb_layout

> The same layouts from `setxkbmap` apply.

## 2. Install a display manager / login manager
```sh
# sddm is recommended for KDE plasma
sudo pacman -S sddm
```


## 3. Enable services on startup
```sh
systemctl enable sddm.service
systemctl enable NetworkManager.service
```

`wireplumber`

- [KDE Plasma for Arch Linux](https://www.debugpoint.com/kde-plasma-arch-linux-install/)


For a autologin session, edit:

| /etc/sddm.conf.d/autologin.conf |
--
```
[Autologin]
User=user_name
Session=plasma
```

# Qtile

install `qtile` and a compositor (for managing transparecy) like `picom`, also install `kitty`
