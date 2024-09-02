#!/usr/bin/bash

set -e

dotfiles=$(dirname "$(realpath "$0")")

mkdir --verbose --parents \
    ~/.cache \
    ~/.config \
    ~/.local/bin \
    ~/.local/share \
    ~/.local/state \
    ~/Documents \
    ~/Downloads \
    ~/Media/images/screenshots \
    ~/Media/music \
    ~/Media/videos \
    ~/archives \
    ~/bin \
    ~/projects \
    ~/repos

stow --verbose --dir "$dotfiles" --target ~ user

# quote heredoc label to avoid expanding variables
cat >> ~/.bashrc << 'BASH'

# shellcheck source=.config/bash/.bashrc
[[ -f ~/.config/bash/.bashrc ]] && source ~/.config/bash/.bashrc
BASH

if ! command -v paru > /dev/null; then
    # Download the binary version to avoid compilation
    git clone https://aur.archlinux.org/paru-bin.git ~/repos/paru
    cd ~/repos/paru
    makepkg --syncdeps --install
fi

paru -S --needed - < "$dotfiles/system/packages.txt"
paru -S --needed - < "$dotfiles/system/aur-packages.txt"

systemctl --user enable \
    tldrcache.timer \
    org.gnome.GPaste.service

# set keyboard layout
localectl set-x11-keymap latam
