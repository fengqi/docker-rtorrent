#!/bin/sh

case "$1" in
	start)
		echo -n "Starting rtorrent"
		su - root -c "screen -m -d -S rtorrent /usr/bin/rtorrent" & > /dev/null
		echo "."
		;;

	stop)
		echo -n "Stopping rtorrent"
		ppid=`ps ax | grep "/usr/bin/rtorrent" | grep -v grep | grep -v screen | awk '{ print $1 }'`
		kill ${ppid}
		echo "."
		;;

	restart)
		echo -n "Restarting rtorrent"
		ppid=`ps ax | grep "/usr/bin/rtorrent" | grep -v grep | grep -v screen | awk '{ print $1 }'`
		kill ${ppid}
		sleep 1
		su - root -c "screen -m -d -S rtorrent /usr/bin/rtorrent" & > /dev/null
		echo "."
		;;
		
	*)
		echo "Usage: {start|stop|restart}" >&2
		exit 1
		;;
esac
exit 0
