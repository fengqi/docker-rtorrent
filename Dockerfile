FROM ubuntu:14.04

RUN sed -i 's/archive.ubuntu/cn.archive.ubuntu/g' /etc/apt/sources.list && \
	sed -i 's/security.ubuntu/cn.archive.ubuntu/g' /etc/apt/sources.list && \
	apt-get update

RUN	apt-get -y install libtool libxmlrpc-c++8-dev libsigc++-2.0-dev libcppunit-dev \
	libncurses5-dev libcurl4-openssl-dev libcrypto++-dev libssl-dev g++ automake \
	autoconf make nginx php5-fpm php5-cli unzip unrar curl screen mediainfo

COPY src/libtorrent-0.13.4 /opt/libtorrent-0.13.4
RUN cd /opt/libtorrent-0.13.4 && \
	./autogen.sh && \
	./configure --prefix=/usr && \
	make && \
	make install

COPY src/rtorrent-0.9.4 /opt/rtorrent-0.9.4
RUN	cd /opt/rtorrent-0.9.4 && \
	./autogen.sh && \
	./configure --prefix=/usr --with-xmlrpc-c && \
	make && make install

COPY boot.sh /app/boot.sh
COPY rtorrent.rc /root/.rtorrent.rc
COPY init.d.sh /etc/init.d/rtorrent
COPY rutorrent.conf /etc/nginx/sites-available
COPY src/ruTorrent-3.8 /usr/share/nginx/ruTorrent

RUN	chown -R www-data:www-data /usr/share/nginx/ruTorrent && \
	chmod +x /etc/init.d/rtorrent && \
	chmod +x /app/boot.sh && \
	unlink /etc/nginx/sites-enabled/* && \
	ln -s /etc/nginx/sites-available/rutorrent.conf /etc/nginx/sites-enabled && \
	mkdir -p /app/session && \
	mkdir -p /app/downloads

EXPOSE 8090

CMD sh /app/boot.sh
