# Contributor: Peter Bui <pnutzh4x0r@gmail.com>
# Contributor: Sören Tempel <soeren+alpine@soeren-tempel.net>
# Contributor: Bartłomiej Piotrowski <nospam@bpiotrowski.pl>
# Maintainer: Jakub Jirutka <jakub@jirutka.cz>

pkgname=rtorrent
pkgver=0.9.4
pkgrel=0
pkgdesc="Ncurses BitTorrent client based on libTorrent"
url="http://rakshasa.github.io/rtorrent/"
license="GPL"
arch="all"
makedepends="libsigc++-dev curl-dev xmlrpc-c-dev ncurses-dev libressl-dev"
subpackages="$pkgname-doc"
source="https://tools.fengqi.me/$pkgname-$pkgver.tar.gz"
builddir="$srcdir/$pkgname-$pkgver"

prepare() {
	cd "$builddir"
	update_config_sub || return 1
	patch -p0 -i /opt/patch/rtorrent.patch  || return 1	
}
 
build() {
	cd "$builddir"
	./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--localstatedir=/var \
		--enable-ipv6 \
		--disable-debug \
		--with-xmlrpc-c \
		|| return 1
	make || return 1
}

package() {
	cd "$builddir"
	make DESTDIR="$pkgdir" install || return 1
	install -Dm644 doc/rtorrent.rc "$pkgdir"/usr/share/doc/rtorrent/rtorrent.rc
}

md5sums="fd9490a2ac67d0fa2a567c6267845876  rtorrent-0.9.4.tar.gz"
sha256sums="bc0a2c1ee613b68f37021beaf4e64a9252f91ed06f998c1e897897c354ce7e84  rtorrent-0.4.6.tar.gz"
sha512sums="ae243d0336acff50e91e4ed9d306beb4705559775518e6dc122ec18a1530e59e2c531cf54f4b79899a1569ca18d343fce255071b45c41df1357bddfe926692aa  rtorrent-0.9.4.tar.gz"