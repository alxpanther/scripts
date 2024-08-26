FROM oraclelinux:9-slim

MAINTAINER Alexander Fedorko <alx69@ukr.net>

LABEL maintainer="Alexander Fedorko <alx69@ukr.net>" \
 project_name="Errors from Exim log to Telegram" \
 from_os="OracleLinux 9"

RUN mkdir -p /root/logs
COPY mail2telegram.sh /root/
COPY search2telegram.sh /root/

WORKDIR /root/

CMD ["bash", "/root/mail2telegram.sh"]
