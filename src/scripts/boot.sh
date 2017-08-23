#!/bin/sh

# 默认配置文件
if [ ! -f "/app/conf/rtorrent.rc" ];then
    cp /opt/src/scripts/rtorrent.rc /app/conf/
fi

if [ ! -f "/app/conf/rutorrent.php" ];then
    cp /opt/src/scripts/rutorrent.php /app/conf/
fi

# 每次运行都是用用户配置覆盖
cp /app/conf/rtorrent.rc /root/.rtorrent.rc
cp /app/conf/rutorrent.php /usr/share/nginx/ruTorrent/conf/config.php

# 解锁
rm -rf /app/sessions/rtorrent.lock

# 启动程序
/etc/init.d/php5-fpm start
/etc/init.d/rtorrent start
/usr/sbin/nginx -g "daemon off;"
