#!/bin/sh

trap "kill $!" SIGINT SIGTERM
nginx
php-fpm
#nginx -g "daemon off;"
