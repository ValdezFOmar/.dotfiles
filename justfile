set default-list := true

install: clean gen-source
    sudo install -Dm644 etc/reflector.conf /etc/xdg/reflector/reflector.conf
    makepkg --syncdeps --install

[doc("Generate source.tar for PKGBUILD")]
gen-source:
    tar --create --file source.tar LICENSE etc/ --directory home/dot-config/hypr/ wallpapers/
    updpkgsums

lint: gen-source
    makepkg --verifysource --force
    makepkg --cleanbuild --force
    namcap PKGBUILD *.tar.zst

[doc("Delete generated artifacts")]
clean:
    rm -rf pkg/ src/ *.tar *.tar.gz *.tar.zst *.log *.pkg
