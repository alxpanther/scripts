#!/bin/sh

# Created by Alexander Fedorko (alx69, alx69@ukr.net) 2020-09-20
#
# In /etc/nginx/conf.d create file blockips.conf and add line in config (example site.conf): include conf.d/blockips.conf;

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/X11R6/bin:/home/mon/bin:/home/mon/scripts

tail -n 10000 /var/log/nginx/www-*.access.log | grep "GET /login" | awk '{print $1}'| sort| uniq -c| sort -nr| head -n 10 | awk '{print "deny "$2";"}' >> /etc/nginx/conf.d/blockips.conf && /usr/sbin/nginx -t && /usr/sbin/nginx -s reload
