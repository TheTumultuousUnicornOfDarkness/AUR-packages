# Maintainer: X0rg
# Contributor: honzor <dorhonzor@gmail.com>
# Contributor: Bastien Dejean <baskerville@lavabit.com>

pkgname=dmg2img
pkgver=1.6.5
pkgrel=3
pkgdesc="A CLI tool to uncompress Apple's compressed DMG files to the
HFS+ IMG format"
arch=('i686' 'x86_64')
url='http://vu1tur.eu.org/tools/'
license=('GPL2')
depends=('openssl')
source=("${url}${pkgname}-${pkgver}.tar.gz")
md5sums=('d01b01151759dd25e16d0c37d4a57b3c')
DLAGENTS=('http::/usr/bin/wget -O %o %u')

build() {
    cd "$srcdir/${pkgname}-${pkgver}"
    make PREFIX=/usr
}

package() {
    cd "$srcdir/${pkgname}-${pkgver}"
    make PREFIX=/usr DESTDIR="$pkgdir" install
}
