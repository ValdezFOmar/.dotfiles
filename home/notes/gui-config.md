# GUI

Optional packages:

- `arandr`: Alternative monitor configuration program
- `font-manager`: Simple to use font explorer
- Spelling: Optional for LibreOffice (and other programs)
  - `hunspell-en_us`: Spelling for American English
  - `hunspell-es_mx`: Spelling for Mexican Spanish
  - `hyphen-es`: Hyphen rules for Spanish

## Qt theme

Dependencies:

- `kvantum`
- `kvantum-theme-materia`
- `qt5ct`

Then follow this instructions

1. Launch **Qt5 settings** (`qt5ct`)
  1. Choose *style > **kvantum-dark***.
2. Launch **Kvantum Manager**
  1. Go to *Change / Delete Theme > Select a Theme*
  2. Choose **MateriaDark**.

## Mozilla

### Firefox

To make windows from external links open in tabs instead, apply the
changes listed in this [article][firefox-tabs].

[firefox-tabs]: https://support.mozilla.org/en-US/questions/1193456

### Thunderbird

To prevent Thunderbird from downloading all your e-mails, change the
settings at *Edit > Account Settings > Synchronisation and Storage* to
**Synchronise the most recent**.

> [!TIP]
> You might need to press `Alt` to see the *Edit* option in top of the window.


## Keyboard Configuration

### Temporal

To see a full list of keyboard models, layouts, variants and options
for X11, along with a short description, do the following:

```sh
less /usr/share/X11/xkb/rules/base.lst
```

To set up the configuration, use the following commands:

> [!NOTE]
> [X11 Keyboard config][x11-keyboard-config] ArchWiki article.

```sh
setxkbmap -model xkb_model
setxkbmap -layout xkb_layout
setxkbmap -variant xkb_variant
setxkbmap -option xkb_options
```

> [!TIP]
> For a Latin American keyboard layout use: `setxkbmap -layout latam`.

### Persistent

For a persistent keyboard layout configuration use this command
instead (reboot to see changes):

```sh
localectl set-x11-keymap skb_layout
```

> [!NOTE]
> The same layouts from `setxkbmap` apply.

[x11-keyboard-config]: https://wiki.archlinux.org/title/Xorg/Keyboard_configuration
