# GUI

Optional packages:

- `arandr`: Alternative monitor configuration program
- `font-manager`: Simple to use font explorer
- Spelling: Optional for LibreOffice (and other programs)
  - `hunspell-en_us`: Spelling for American English
  - `hunspell-es_mx`: Spelling for Mexican Spanish
  - `hyphen-es`: Hyphen rules for Spanish

## Display Manager (DM) and Session Greeter

This setup uses `lightdm` as the DM and `lightdm-slick-greeter` as the
session greeter. To set up the session greeter for LightDM, edit the
following line in `/etc/lightdm/lightdm.conf`:

```
[Seat:*]
...
greeter-session=lightdm-slick-greeter
...
```

> [!IMPORTANT]
> Is necessary to set this attribute to be able to login.


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

### Nomacs Image Viewer

> [!IMPORTANT]
> **Optional**
> Only available in the `AUR` and needs compilation every update.
> Not recommended for now, but it has been the best image viewer
> that I found.

Dependencies:

- `nomacs`

Go to *Edit > Settings* and add necessary changes.


## Qtile

Install `qtile` and a compositor (for managing transparency) like `picom`.

> [!TIP]
> Qtile **log messages** can be found at `~/.local/share/qtile/qtile.log`.

To have a Qtile logo appear on `lightdm-slick-greeter`'s list of
sessions, place a `.png` image under `/usr/share/slick-greeter/badges/`
matching the name of the session's `.desktop` entry in
`/usr/share/xsessions/`. In this case, the icon name should be `qtile.png`.

> [!NOTE]
> Check [slick-greeter source code][slick-greeter-icons] for this behavior.


## Change cursor

After downloading and extracting the cursor theme, copy its contents to
`~/.local/share/icons`. Then to select it as the current cursor theme,
launch `lxappearance` and apply the theme. Finally, to have it
automatically be set up at logging, simply symlink the `cursors`
directory from the cursors' theme directory to `~/.icons/default/cursors`.

An example might be:

```sh
ln -s ~/.local/share/icons/[theme_name]/cursors ~/.icons/default/cursors
```


## Monitor Layout

> [!TIP]
> Consider using `lxrandr` instead (`lxrandr-gtk3` package).

Use `autorandr` for configuring multi monitors, use the following options:

> [!NOTE]
> You still need to preconfigured the displays with `xrandr` and then
> saved them with `autorandr`

- `autorandr --save <config-name>` For saving the current configuration.
- `autorandr --default <config-name>` For making a configuration default
  when no other is detected.

> [!IMPORTANT]
> This overrides the default behavior that makes `autorandr` keep the current
> configuration even when monitors are connected/disconnected


[slick-greeter-icons]: https://github.com/linuxmint/slick-greeter/blob/master/src/session-list.vala#L109
