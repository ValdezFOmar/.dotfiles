# shellcheck shell=bash disable=SC2034,SC2164,SC2154

pkgname=dotfiles-system
pkgver=2026.11.04
pkgrel=1
pkgdesc='Custom system files'
url='https://github.com/ValdezFOmar/.dotfiles'
license=('MIT')
arch=('any')
source=('source.tar')
sha256sums=('f8814c4c536716c3dbd9025db83f64f0284d99f8c06c55b995213f9c9bf0770a')

package() {
    cd "$srcdir"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
    install -Dm644 etc/greeter/greetd.conf "$pkgdir/etc/greetd/greetd.conf"
    install -Dm644 etc/greeter/hyprland.lua "$pkgdir/etc/nwg-hello/hyprland.lua"
    install -Dm644 etc/greeter/nwg-hello.css "$pkgdir/etc/nwg-hello/nwg-hello.css"
    install -Dm644 etc/limits.conf "$pkgdir/etc/security/limits.d/99-nproc.conf"
    install -Dm644 -t "$pkgdir/usr/share/backgrounds/dotfiles" wallpapers/*
}
