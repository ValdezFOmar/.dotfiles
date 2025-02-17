#!/usr/bin/bash

# Exit on errors
set -o errexit
set -o nounset
set -o pipefail

# Print commands as they are executed
set -o xtrace

dotfiles=$(dirname "$(realpath "$0")")

mkdir --verbose --parents \
    ~/.cache \
    ~/.config \
    ~/.local/bin \
    ~/.local/share \
    ~/.local/state \
    ~/Documents \
    ~/Downloads \
    ~/Pictures/Screenshots \
    ~/Music \
    ~/Videos \
    ~/archives \
    ~/projects \
    ~/repos

stow --verbose --dir "$dotfiles" --target ~ home

# quote heredoc label to avoid expanding variables
cat >> ~/.bashrc << 'BASH'

# shellcheck source=.config/bash/.bashrc
[[ -f ~/.config/bash/.bashrc ]] && source ~/.config/bash/.bashrc
BASH

if ! command -v paru > /dev/null; then
    # Download the binary version to avoid compilation
    git clone https://aur.archlinux.org/paru-bin.git ~/repos/paru-bin
    cd ~/repos/paru-bin
    makepkg --syncdeps --install
    cd -
fi

paru -S --needed - < "$dotfiles/etc/packages.txt"
paru -S --needed - < "$dotfiles/etc/packages-aur.txt"
xargs pipx install < "$dotfiles/etc/packages-pypi.txt"

systemctl --user enable \
    tldrcache.timer \
    hyprpaper.service \
    hypridle.service \
    waybar.service
