#!/bin/bash

# Created by Alexander Fedorko (alx69, alx69@ukr.net) 2020-09-20

DOMAINS=( serveradmin.ru server.pro )

THIS_DATE=`date +"%Y-%m-%d"`

for domain in "${DOMAINS[@]}"
  do
    testing_domain=`whois $domain|egrep -i "expiry|expiries|paid-till" | grep -Eo '[0-9]{4}-[0-9]{2}-[0-9]{2}'`

    if [ "$testing_domain" == "" ]
      then
        echo "Не удалось получить корректных данных по домену: $domain"

    fi

    exp_days=$(( ($(date -d $testing_domain  +%s) - $(date -d $THIS_DATE +%s)) / 86400 ))

    if [ "$exp_days" -le 15 ]
      then
        echo "Домен $domain скоро проэкспайрится! Осталось $exp_days!"
    fi

    echo "Домену $domain еще $exp_days до отключения."

done
