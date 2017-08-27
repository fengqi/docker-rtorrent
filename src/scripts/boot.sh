#!/bin/sh

# 默认配置文件
[ ! -f "/app/conf/nginx.conf" ] && cp -r /opt/conf/nginx.conf /app/conf/
[ ! -f "/app/conf/httpPassword" ] && echo "admin:zOfptPkebiKR." > /app/conf/httpPassword
[ ! -f "/app/conf/php.ini" ] && cp -r /opt/conf/php.ini /app/conf/
[ ! -f "/app/conf/php-fpm.conf" ] && cp -r /opt/conf/php-fpm.conf /app/conf/
[ ! -f "/app/conf/rtorrent.rc" ] && cp -r /opt/conf/rtorrent.rc /app/conf/
[ ! -f "/app/conf/rutorrent.php" ] && cp -r /opt/conf/rutorrent.php /app/conf/

# 每次运行都使用用户配置覆盖
cp -r /app/conf/nginx.conf /etc/nginx/
cp -f /app/conf/httpPassword /etc/nginx/
cp -r /app/conf/php.ini /etc/php5/
cp -r /app/conf/php-fpm.conf /etc/php5/
cp -f /app/conf/rtorrent.rc /root/.rtorrent.rc
cp -f /app/conf/rutorrent.php /var/www/ruTorrent/conf/config.php

# 权限修正
chmod 644 /etc/nginx/nginx.conf \
	/etc/nginx/httpPassword \
	/etc/php5/php.ini \
	/etc/php5/php-fpm.conf \
	/root/.rtorrent.rc \
	/var/www/ruTorrent/conf/config.php

# 解锁
rm -rf /app/sessions/rtorrent.lock

# 启动程序
php-fpm5 -c /etc/php5/php-fpm.conf
screen -d -m /usr/bin/rtorrent
nginx -c /etc/nginx/nginx.conf -g "daemon off;"
