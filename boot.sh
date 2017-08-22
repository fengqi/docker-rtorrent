#!/bin/sh

/etc/init.d/php5-fpm start
/etc/init.d/rtorrent start
/usr/sbin/nginx -g "daemon off;"
