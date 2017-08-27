FROM alpine:3.6

ADD src /opt

RUN apk add --no-cache --allow-untrusted \
	php5-fpm php5-cli php5-opcache php5-json nginx \
	wget unzip unrar screen curl \
	/opt/apk/libtorrent-0.13.4-r0.apk /opt/apk/rtorrent-0.9.4-r0.apk && \
	ln -s /usr/bin/php5 /usr/bin/php

ADD https://tools.fengqi.me/ruTorrent-3.8.tar.gz /opt/ruTorrent-3.8.tar.gz
RUN cd /opt && \
	tar -zxf ruTorrent-3.8.tar.gz && \
	cd ruTorrent-3.8 && \
	patch -p0 -i /opt/patch/rutorrent.patch && \
	mv /opt/ruTorrent-3.8 /var/www/ruTorrent && \
	chown -R nginx:nginx /var/www/ruTorrent

EXPOSE 8090 60103
VOLUME ["/app/sessions", "/app/downloads", "/app/conf", "/app/watch"]

CMD sh /opt/scripts/boot.sh
