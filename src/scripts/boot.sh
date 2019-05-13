#!/bin/sh

# 默认配置文件
[ ! -f "/app/conf/rtorrent.rc" ] && cp /opt/conf/rtorrent.rc /app/conf/
[ ! -f "/app/conf/rutorrent.php" ] && cp /opt/conf/rutorrent.php /app/conf/
[ ! -f "/app/conf/rutorrent.conf" ] && cp /opt/conf/rutorrent.conf /app/conf/

# 默认密码 123456
[ ! -f "/app/conf/httpPassword" ] && echo "admin:zOfptPkebiKR." > /app/conf/httpPassword

# 每次运行都是用用户配置覆盖
cp -f /app/conf/rtorrent.rc /root/.rtorrent.rc
cp -f /app/conf/rutorrent.php /app/ruTorrent/conf/config.php
cp -f /app/conf/httpPassword /etc/nginx/httpPassword
cp -f /opt/conf/rutorrent.conf /etc/nginx/sites-available/rutorrent.conf

# 权限修正
chmod 644 /etc/nginx/httpPassword \
		/root/.rtorrent.rc \
		/app/ruTorrent/conf/config.php \
		/etc/nginx/sites-available/rutorrent.conf

chmod -R 777 /app/*

# 解锁
rm -rf /app/sessions/rtorrent.lock

# 启动程序
/etc/init.d/php7.0-fpm restart
/etc/init.d/nginx restart
/usr/bin/rtorrent
