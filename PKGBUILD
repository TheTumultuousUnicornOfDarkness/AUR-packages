# Maintainer: X0rg
# Contributor: Hugo Osvaldo Barrera <hugo@barrera.io>

_realname=lLyrics
pkgname=rhythmbox-llyrics
pkgver=1.2
pkgrel=1
pkgdesc="A Rhythmbox plugin for displaying lyrics in the sidebar"
arch=('any')
url="https://github.com/dmo60/lLyrics"
license=('GPL2')
makedepends=('git')
depends=('rhythmbox>=3.0' 'python-chardet' 'python-lxml')
source=("https://github.com/dmo60/lLyrics/archive/v$pkgver.tar.gz")
md5sums=('5ae4319f10ff7813e2b5bc7b68f5e49f')

prepare() {
	cd "$srcdir/$_realname-$pkgver"
	sed -i 's|sudo||g'               "Makefile"
	sed -i 's|lib64|lib|g'           "Makefile"
	sed -i 's|/usr|$(PREFIX)/usr|g'  "Makefile"
	sed -i '/glib-compile-schemas/d' "Makefile"
}

package() {
	cd "$srcdir/$_realname-$pkgver"
	mkdir -p "$pkgdir/usr/lib/rhythmbox/plugins/"
	mkdir -p "$pkgdir/usr/share/glib-2.0/schemas/"
	make PREFIX="$pkgdir" install-systemwide
}
