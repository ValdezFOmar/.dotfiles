# TODO

## .dotfiles

- [x] Change python scripts' names in `install/` (`-` to `_`)
- [x] fixed the implicit relative imports, so is possible to run the scripts like
      `python -m install.user_config`. Maybe even consider adding a `__main__`
      to run it like this: `python -m install`

## Kitty

- [ ] Replace `CaskaydiaCove NF` for plain `CascadiaCode` and use kitty's Unicode points
      options for displaying all kinds of special symbols. This will solve the issue with
      some ligatures (like `<<=` and `|-`). Keep the Nerd Font variant since is use in other
      programs (mainly `rofi`).

## General

- [ ] Look into [`polkit`](https://polkit.pages.freedesktop.org/polkit/) for creating rules to
      call `cpupower frequency-set` without root permission.
- [ ] Create a `pacman` hook for notifying the user when a new kernel update happened
      to remember to reboot the system after it so the new kernel modules are loaded
- [x] Consider changing python workflow by using `virtualenv` instead of `venv` builtin module
- [x] ~Write my own image viewer LOL (in python)~ I just made a simple script
- [ ] Look into configuring Firefox with a plain text file
- [ ] Learn [touch typing](https://www.typingclub.com/)
- [ ] Configure a better [locale](https://wiki.archlinux.org/title/Locale) and add environmental variables
- [ ] Configure Bluetooth

## Neovim

- [ ] Make `nvim` plugins lazy loaded
- [x] Change `lua` formatting
  - [x] Change in `stylua.toml`
  - [x] Change in `.editorconfig`
  - [x] Change in `nvim/after/ftplugin/lua.lua`
  - [x] Indentation from 2 to 4 spaces
  - [x] From double to single quotes `"AutoPreferSingle"`
- [x] Change keymaps for overload window because is conflicting when using autocompletion
- [ ] Apply configurations from [this repo](https://github.com/mjlbach/starter.nvim)
      like the following:

  ```lua
  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
  vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)
  ```


## Qtile
- [x] Add group for Thunderbird
- [ ] Re-enable system tray for qtile and install Thunderbird system tray icon `systray-x-common`

## Rofi
- [ ] Create a `simple_dmenu.rasi` shared between multiple menu that don't use icons
  - [x] Import the base theme (`config.rasi`) from it and then only include the file name with the option
  - [x] `-theme` instead of using `-theme-str`
  - [x] Disable icons in the file
  - [x] Make `config.rasi` the fallback in scripts

## BASH Prompt (`PS1`)

- [ ] Fix `PS1` crazy escape sequences because they are pretty confusing right now. See: [Bash escape sequences](/notes/tips.md#bash-escape-sequences)


# Completed

## General

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
