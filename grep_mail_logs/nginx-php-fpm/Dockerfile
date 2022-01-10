FROM centos:8

MAINTAINER Alexander Fedorko <alx69@ukr.net>

LABEL maintainer="Alexander Fedorko <alx69@ukr.net>" \
 project_name="PHP Grep for Exim E-Mail's" \
 from_os="Centos 8"

RUN dnf -y install \
 bind-utils \
# mc \
 nginx \
# net-tools \
 curl \
 openssl \
 ca-certificates \
# iputils \
# procps \
 php-cli php-common \
 php-fpm \
 && dnf clean all

RUN mkdir -p /run/php-fpm

COPY php.d/10-local.ini /etc/php.d/
COPY nginx /etc/nginx/
COPY entrypoint.sh /

RUN touch /usr/share/nginx/html/favicon.ico

COPY grep_logs.php /usr/share/nginx/html/index.php

WORKDIR /usr/share/nginx/html

ENTRYPOINT ["/entrypoint.sh"]
