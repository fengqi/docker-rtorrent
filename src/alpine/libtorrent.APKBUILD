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
source="https://tools.fengqi.me/$pkgname-$pkgver.tar.gz"
builddir="$srcdir/$pkgname-$pkgver"

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

md5sums="e82f380a9d4b55b379e0e73339c73895  libtorrent-0.13.4.tar.gz"
sha256sums="704e097119dc89e2ee4630396b25de1cd64b0549841347ea75b9ef9217084955  libtorrent-0.13.4.tar.gz"
sha512sums="6a5ea944c1193d1160563828c5901f0cf557f38c4de61153d505344f3c3c8509c765e01b6cc5e3a53ec2bb184a9e8db32ed4ec154e93a93822804210f0fa45d0  libtorrent-0.13.4.tar.gz"