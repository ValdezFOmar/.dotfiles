# TIPS

## Links

- [LaTeX Short Guide](https://github.com/oetiker/lshort)

## Git

### Branches

Delete local branch

```sh
git branch -d <branch-name>
```

Delete remote branch

```sh
git push -d origin <remote-branch-name>
```

## General

### Pacman/Paru colors

To enable colored output, edit `/etc/pacman.conf` and uncomment
the `Color` option.

### BASH Escape Sequences

Replace color codes with the following syntax. `setaf` stands for
'**set** **A**NSI **f**oreground'. This syntax can only be embedded in
double quotes. Also note that `$` need to be escaped for commands and
variables that are intended to be evaluated each time the prompt is
printed, else they would only be evaluated the first time.

```sh
# Here a 'number' can be any in the range of 0 to 15
# use `tput sgr 0` to reset all the properties
color="\[$(tput setaf number)\]"

# Escape '$' by placing a '\' before it
PS1="$color \$(date +%M:%S) $ "
```

Variables that contain escapes (`\[` and `\]`) will not properly escape
the ANSI escape code in `PS1` when:

- use inside literal strings (single quotes `''`)
- it's escaped (`\$`) inside a double quoted string
- it's escaped inside a literal string (it will just print the literal variable name)
