#!/bin/sh

trap "kill $!" SIGINT SIGTERM
php-fpm
nginx -g "daemon off;"
