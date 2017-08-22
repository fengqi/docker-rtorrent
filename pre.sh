#!/bin/bash

mkdir src 
cd src

wget -c http://rtorrent.net/downloads/libtorrent-0.13.4.tar.gz && \
wget -c http://rtorrent.net/downloads/rtorrent-0.9.4.tar.gz && \
wget -c https://github.com/Novik/ruTorrent/archive/v3.8.tar.gz -O ruTorrent-3.8.tar.gz

tar -zxf libtorrent-0.13.4.tar.gz
tar -zxf rtorrent-0.9.4.tar.gz
tar -zxf ruTorrent-3.8.tar.gz

patch -p0 -d libtorrent-0.13.4/ < ../patch/libtorrent.patch
patch -p0 -d rtorrent-0.9.4/ < ../patch/rtorrent.patch
patch -p0 -d ruTorrent-3.8/ < ../patch/rutorrent.patch

cd ../
