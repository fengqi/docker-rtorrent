# Contributor: Peter Bui <pnutzh4x0r@gmail.com>
# Contributor: Bartłomiej Piotrowski <nospam@bpiotrowski.pl>
# Maintainer: Jakub Jirutka <jakub@jirutka.cz>

pkgname=libtorrent
pkgver=0.13.4
pkgrel=0
pkgdesc="BitTorrent library written in C++"
url="http://rakshasa.github.io/rtorrent/"
arch="all"
license="GPL"
makedepends="zlib-dev libsigc++-dev libressl-dev"
subpackages="$pkgname-dev"
options="libtool"
source="http://rtorrent.net/downloads/$pkgname-$pkgver.tar.gz"
builddir="$srcdir/$pkgname-$pkgver"

prepare() {
	cd "$builddir"
	patch -p0 -i /opt/patch/libtorrent.patch  || return 1	
}

build() {
	cd "$builddir"

	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--disable-debug \
		--disable-instrumentation \
		|| return 1
	make || return 1
}

package() {
	cd "$builddir"
	make DESTDIR="$pkgdir" install || return 1
}
