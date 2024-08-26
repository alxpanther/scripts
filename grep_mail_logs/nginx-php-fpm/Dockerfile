#FROM php:8-fpm-bookworm
FROM php:7.3-fpm-stretch

MAINTAINER Alexander Fedorko <alx69@ukr.net>

LABEL maintainer="Alexander Fedorko <alx69@ukr.net>" \
 project_name="PHP Grep for Exim E-Mail's"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && apt-get -y install --no-install-recommends openssl curl gnupg2 ca-certificates lsb-release debian-archive-keyring
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

RUN apt -y install --no-install-recommends nginx

RUN mkdir -p /run/php-fpm

COPY php.d/10-local.ini /etc/php.d/
COPY nginx /etc/nginx/
COPY entrypoint.sh /

RUN touch /usr/share/nginx/html/favicon.ico

COPY grep_logs.php /usr/share/nginx/html/index.php

WORKDIR /usr/share/nginx/html

ENTRYPOINT ["/entrypoint.sh"]
