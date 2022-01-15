#!/bin/bash

export PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/local/sbin

from_email=`echo $1 | awk '{print $8}' | xargs -d '\n' -IXXX  grep --line-buffered XXX logs/maillog | egrep --line-buffered 'esmtps' | awk '{print $10}'`

/usr/bin/curl --connect-timeout 3 -s -X POST https://api.telegram.org/${BOT_ID}/sendMessage -d chat_id=${CHAT_ID} -d parse_mode="none" -d disable_web_page_preview="true" -d text="From E-Mail: $from_email%0A$1" > /dev/null
