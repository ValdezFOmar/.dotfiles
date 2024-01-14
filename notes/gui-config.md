# GUI


## Display Manager (DM) and Session Greeter

This setup uses `lightdm` as the DM and `lightdm-slick-greeter` as the session greeter.
To set up the session greeter for LightDM, edit the following line in `/etc/lightdm/lightdm.conf`:

```
[Seat:*]
...
greeter-session=lightdm-slick-greeter
...
```

> **NOTE:** its important to set this attribute to be able to login.


## Qtile

Install `qtile` and a compositor (for managing transparecy) like `picom`.

> Qtile **log messages** can be found at `~/.local/share/qtile/qtile.log`.

To have a Qtile logo appear on
`lightdm-slick-greeter`'s list of sessions, place a `.png` image under `/usr/share/slick-greeter/badges/`
matching the name of the session's `.desktop` entry in `/usr/share/xsessions/`. In this case, the icon name
should be `qtile.png`.

> Check [slick-greeter source code](https://github.com/linuxmint/slick-greeter/blob/master/src/session-list.vala#L109)
> for this behavior.


## Change cursor

After downloading and extracting the cursor theme, copy its contents to `~/.local/share/icons`.
Then to select it as the current cursor theme, launch `lxappearance` and apply the theme.
Finally, to have it automatically be set up at logging, simply symlink the `cursors` directory
from the cursors' theme directory to `~/.icons/default/cursors`. An example might be:

```sh
ln -s ~/.local/share/icons/[theme_name]/cursors ~/.icons/default/cursors
```


## Monitor Layout

> **NOTE:** Consider using `lxrandr` instead (`lxrandr-gtk3` package).

Use `autorandr` for configuring multimonitors, use the following options:

> You still need to preconfigured the displays with `xrandr` and then saved them with `autorandr`

- `autorandr --save <config-name>` For saving the current configuration
- `autorandr --default <config-name>` For making a configuration default when not other is detected

> This overrides the default behavior that makes `autorandr` keep the current
> configuration even when monitors are connected/disconnected
