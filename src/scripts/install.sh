#!/bin/sh

# 切换国内源
sed -i 's/archive.ubuntu/cn.archive.ubuntu/g' /etc/apt/sources.list
sed -i 's/security.ubuntu/cn.archive.ubuntu/g' /etc/apt/sources.list

# 安装依赖包
apt-get update && \
apt-get -y --no-install-recommends install libtool libxmlrpc-c++8-dev \
		libsigc++-2.0-dev libcppunit-dev libncurses5-dev libcurl4-openssl-dev \
		libcrypto++-dev libssl-dev g++ automake autoconf make nginx php5-fpm \
		php5-cli curl screen wget patch

# 下载源码, 非最新版本
mkdir -p /opt/src;cd /opt/src
wget -c --no-check-certificate http://rtorrent.net/downloads/libtorrent-0.13.4.tar.gz && \
wget -c --no-check-certificate http://rtorrent.net/downloads/rtorrent-0.9.4.tar.gz && \
wget -c --no-check-certificate https://github.com/Novik/ruTorrent/archive/v3.8.tar.gz -O ruTorrent-3.8.tar.gz

# 编译安装 libtorrent
tar -zxf libtorrent-0.13.4.tar.gz
patch -p0 -d libtorrent-0.13.4/ < /opt/src/patch/libtorrent.patch
cd libtorrent-0.13.4
./autogen.sh && \
./configure --prefix=/usr && \
make && \
make install && cd ../

# 编译安装 rtorrent
tar -zxf rtorrent-0.9.4.tar.gz
patch -p0 -d rtorrent-0.9.4/ < /opt/src/patch/rtorrent.patch
cd rtorrent-0.9.4
./autogen.sh && \
./configure --prefix=/usr --with-xmlrpc-c && \
make && \
make install && cd ../
cp /opt/src/scripts/rtorrent.sh /etc/init.d/rtorrent
chmod +x /etc/init.d/rtorrent

# 安装 rutorrent
tar -zxf ruTorrent-3.8.tar.gz
patch -p0 -d ruTorrent-3.8/ < /opt/src/patch/rutorrent.patch
mv /opt/src/ruTorrent-3.8 /usr/share/nginx/ruTorrent
chown -R www-data:www-data /usr/share/nginx/ruTorrent
sed -i "s/^post_max_size.*$/post_max_size = 100M/" /etc/php5/fpm/php.ini
sed -i "s/^upload_max_filesize.*$/upload_max_filesize = 100M/" /etc/php5/fpm/php.ini

# 配置 nginx
cp /opt/src/scripts/rutorrent.conf /etc/nginx/sites-available
unlink /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/rutorrent.conf /etc/nginx/sites-enabled

# 清理
apt-get autoremove -y g++ automake autoconf make wget patch libtool
dpkg -l|grep ^rc|awk '{print $2}'|xargs dpkg -P
rm -rf /var/lib/apt/lists/*
rm -rf /opt/src/libtorrent-*
rm -rf /opt/src/ruTorrent-*
rm -rf /opt/src/rtorrent-*

# 运行时目录
mkdir -p /app/conf
mkdir /app/sessions
mkdir /app/downloads
