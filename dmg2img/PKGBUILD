# Maintainer: X0rg
# Contributor: honzor <dorhonzor@gmail.com>
# Contributor: Bastien Dejean <baskerville@lavabit.com>

pkgname=dmg2img
pkgver=1.6.7
pkgrel=1
pkgdesc="A CLI tool to uncompress Apple's compressed DMG files to the HFS+ IMG format"
arch=('i686' 'x86_64')
url='http://vu1tur.eu.org/tools/'
license=('GPL2')
depends=('openssl' 'bzip2')
source=("http://vu1tur.eu.org/tools/$pkgname-$pkgver.tar.gz")
md5sums=('1f0e66285ee4a46b480f3130bc112512')

build() {
	cd "$srcdir/$pkgname-$pkgver"
	make PREFIX="/usr"
}

package() {
	cd "$srcdir/$pkgname-$pkgver"
	make PREFIX="/usr" DESTDIR="$pkgdir" install
}
