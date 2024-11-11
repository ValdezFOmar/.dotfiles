# TODO

## General

- [ ] Move env vars in `.xprofile` to a separate file in order to be able
  to source it and export the variables in environments where `.xprofile`
  might not run (like Termux) (Maybe export a variable like
  `_BONES_LOADED_ENVS`, if it's set the don't load them again, if it's
  not then load'em).
- [ ] Home directory cleaning
  - [ ] Move `.wine` prefix to `$XDG_STATE_HOME/wine`
  - [x] Move `.cargo` to `$XDG_STATE_HOME/cargo` and add `cargo/bin`
    to `$HOME`
  - [x] Move `.rustup` to `$XDG_STATE_HOME/rustup`
  - [ ] Move `.screenlayout` to `$XDG_STATE_HOME/layout` and fix
    reference in `.xprofile`
- [ ] Look into configuring Firefox with a plain text file
- [ ] Configure Bluetooth

## .dotfiles

- [ ] Create widgets with <https://github.com/elkowar/eww>
- [ ] Add some options to the `install.sh` script for easier
   installation in other platforms (`termux`).
- [ ] Don't create `~/bin` directory and instead make it a symbolic link
  to `~/.dotfiles/home/bin` since some language servers seem to break
  when the parent directory is a symlink.
- [ ] Add configuration files
  - [x] Add paru configuration
  - [x] Add `readline` configuration `inputrc` and set `INPUTRC` env var
  - [ ] Add yazi configuration
  - [ ] Add `mpv` config
  - [ ] Add `.ssh/config` config
  - [ ] Add mime apps configuration

### pre-commit

- [ ] Add `pre-commit` hooks for linting and formatting shell scripts:
  - [ ] Format all shell scripts
  - [ ] Include the changes specified in `.editorconfig`
  - [ ] <https://github.com/scop/pre-commit-shfmt>
  - [ ] <https://github.com/shellcheck-py/shellcheck-py>

- [ ] Add `pre-commit` hook for formatting markdown files: <https://mdformat.readthedocs.io/en/stable/>
  - [ ] Format all markdown files

## Kitty

- [ ] Replace `CaskaydiaCove NF` for plain `CascadiaCode` and use kitty's
  Unicode points options for displaying all kinds of special symbols.
  This will solve the issue with some ligatures (like `<<=` and `|-`). Keep
  the Nerd Font variant since is use in other programs (mainly `rofi`
  and `qtile`).

## Neovim

- [ ] Heavy refactor of settings, keymaps, etc. into `init.lua`
- [ ] Move some configuration of `after/ftplugin` to an autocommand
- [ ] Move queries out of `after/queries` and into `queries/`
- [ ] Add snippets in vs-code format (JSON files basically)
- [ ] Default indentation of 2 for `test` files
- [ ] Consider using [nvim-highlight-colors] instead of `nvim-colorizer`
   as it's unmaintained.
- [ ] Add highlight groups for C# doc comments. Omnisharp reports semantic
  tokens in the form of `@lsp.type.xmlDocument*`, so this highlight
  groups should be linked to a tag highlight groups (like `@tag.*`).
  A complete list of all the semantic tokens can be found at [the roslyn repository][roslyn-semantic-tokens]

## Rofi
- [ ] Create a `simple_dmenu.rasi` shared between multiple menu that don't use icons
  - [x] Import the base theme (`config.rasi`) from it and then only include the file name with the option
  - [x] `-theme` instead of using `-theme-str`
  - [x] Disable icons in the file
  - [x] Make `config.rasi` the fallback in scripts



# Completed

## .dotfiles

- [x] Change python scripts' names in `install/` (`-` to `_`)
- [x] fixed the implicit relative imports, so is possible to run the scripts like
  `python -m install.user_config`. Maybe even consider adding a `__main__`
  to run it like this: `python -m install`

## General

- [x] Change frequencymenu script to be a shellscript for use in a terminal
- [x] Cleanup shellscripts that are not needed (*_reload.sh files) and
   rename to use hyphens `-`
- [x] Update README.md about new installation script
  - [x] Update scripts and anything that references this change
- [x] Add `XDG_BIN_HOME` environmental variable for programs to install
  executable binaries to.
- [x] Consider changing python workflow by using `virtualenv` instead of `venv` builtin module
- [x] ~Write my own image viewer LOL (in python)~ I just made a simple script
- [x] Add desktop screenshot to README, so it looks cooler B)
- [x] Create a list of AUR installed packages
- [x] Create a hook for list of AUR packages
- [x] Look into configuring Dunst: `https://wiki.archlinux.org/title/Dunst`
- [x] Dunst volume indicator
- [x] Multi monitor configuration
- [x] Add a better handler for cloning repository for cursors theme
  - Instead use one of the AUR `Qogir` themes.
  - ~~Use command `git -C path/to/repo rev-parse --is-inside-work-tree`~~
  - ~~Use `git -C path/to/repo remote get-url`~~
- [x] Delete unnecessary files from home (git integration files)
- [x] Delete `icons` directory, it should not be in version control
- [x] Automate installation with a shellscript (convert the existing
   python scripts).
- [x] ~Look into [`polkit`](https://polkit.pages.freedesktop.org/polkit/) for creating rules to
   call `cpupower frequency-set` without root permission.~
   will be converted to a shellscript, see above
- [x] Use GNU stow for dotfiles management.
  - [x] Move more files under `.config/` and delete them from home
  - [x] Change repo structure to have a single `home` directory at the
     root and all user configuration files will be there
       - [x] Update mentions of this in `install.sh`
  - [x] Rename `system` directory to `etc`
  - [x] Change XDG_BIN_HOME to point to ~/.local/bin and move scripts to ~/bin
    - [x] Delete `PIPX_BIN_HOME` variable, it points to ~/.local/bin by
       default

## Qtile
- [x] Add group for Thunderbird
- [x] Re-enable system tray for qtile and install Thunderbird system tray icon `systray-x-common`


## BASH Prompt (`PS1`)

- [x] Fix `PS1` crazy escape sequences because they are pretty confusing right now. See: [Bash escape sequences](/notes/tips.md#bash-escape-sequences)

## Neovim

- [x] Make `nvim` plugins lazy loaded
- [x] Change `lua` formatting
  - [x] Change in `stylua.toml`
  - [x] Change in `.editorconfig`
  - [x] Change in `nvim/after/ftplugin/lua.lua`
  - [x] Indentation from 2 to 4 spaces
  - [x] From double to single quotes `"AutoPreferSingle"`
- [x] Change keymaps for overload window because is conflicting when using autocompletion

## Rofi
- [x] Improve appearance so it matches the desktop theme (Use dark colors and catpuccin colors for accents)
- [x] Improve existing scripts (Some have horrible code)

## Qtile
- [x] Use icons instead of letters
- [x] But keep using letters for switching groups
- [x] Add Match rules for groups
- [x] Investigate the creation of duplicated keys, move to next version

## Change window appearance
- [x] Add margin around window
- [x] Maybe remove the border when its only one window

## Kitty changes
- [x] Remove option for margin, it causes programs inside the terminal to have an ugly margin
- [x] Add keymaps for opening special files (.dofiles, nvim config, qtile config)
- [x] Use captppuccin colors for terminal

[roslyn-semantic-tokens]: https://github.com/dotnet/roslyn/src/Workspaces/Core/Portable/Classification/ClassificationTypeNames.cs#L57C8-L77C24
[nvim-highlight-colors]: https://github.com/brenoprata10/nvim-highlight-colors
