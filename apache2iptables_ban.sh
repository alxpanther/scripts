#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/X11R6/bin:/home/mon/bin:/home/mon/scripts

tail -n 2000 /var/log/apache2/viland.ua-access.log | awk '/GET \/catalog\/uborka\/raskhodniki HTTP\/1/{print $1}' | sort | uniq -c | sort -n | awk '{if($1>1)print $2}'|xargs -n1 -IZZZ /sbin/ipset add blacklist ZZZ
