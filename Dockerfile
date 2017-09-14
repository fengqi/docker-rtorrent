FROM alpine:3.6

ADD src /opt

RUN apk add --no-cache --virtual=build-dependencies \
		g++ \
		automake \
		autoconf \
		make \
		zlib-dev \
		libsigc++-dev \
		file \
		curl-dev \
		xmlrpc-c-dev \
		ncurses-dev \
		libressl-dev && \
	apk add --no-cache \
		ca-certificates \
		curl \
		php5 \
		php5-fpm \
		php5-cli \
		php5-opcache \
		php5-json \
		nginx \
		wget \
		unzip \
		unrar \
		ffmpeg \
		screen  && \
	ln -s /usr/bin/php5 /usr/bin/php

RUN cd /opt && wget -c http://rtorrent.net/downloads/libtorrent-0.13.4.tar.gz && \
	tar -zxf libtorrent-0.13.4.tar.gz && \
	cd libtorrent-0.13.4 && \
	patch -p0 -i /opt/patch/libtorrent.patch && \
	./configure \
		--prefix=/usr \
		--disable-debug \
		--disable-instrumentation && \
	make && make install

RUN cd /opt && wget -c https://tools.fengqi.me/ruTorrent-3.8.tar.gz && \
	tar -zxf ruTorrent-3.8.tar.gz && \
	cd ruTorrent-3.8 && \
	patch -p0 -i /opt/patch/rutorrent.patch && \
	mv /opt/ruTorrent-3.8 /var/www/ruTorrent && \
	chown -R nginx:nginx /var/www/ruTorrent

RUN cd /opt && wget https://tools.fengqi.me/rtorrent-0.9.4.tar.gz && \
	tar -zxf rtorrent-0.9.4.tar.gz && \
	cd rtorrent-0.9.4 && \
	patch -p0 -i /opt/patch/rtorrent.patch && \
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--localstatedir=/var \
		--enable-ipv6 \
		--disable-debug \
		--with-xmlrpc-c && \
	make && make install

RUN apk del --purge build-dependencies && \
	rm -rf /opt/*.tar.gz

EXPOSE 8090 60103
VOLUME ["/app/sessions", "/app/downloads", "/app/conf", "/app/watch"]

CMD sh /opt/scripts/boot.sh
