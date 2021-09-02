#!/bin/bash

CHAT_ID="XXX"    # Telegram Chat ID
BOT_ID="XXX"     # Telegram Bot ID

#command="/usr/bin/ssh -gfnNT -i ~/.ssh/id_remote_port_rsa -L 127.0.0.1:125:127.0.0.1:25 XXXX@A.B.C.D"
command="/usr/bin/ssh -gfnNT -L 127.0.0.1:3306:127.0.0.1:3306 -p22159 root@A.B.C.D"
if ! pgrep -f "$command" &>/dev/null; then
    $command
    /usr/bin/curl --connect-timeout 10 -s -X POST \
    https://api.telegram.org/${BOT_ID}/sendMessage \
    -d chat_id=${CHAT_ID} \
    -d text="Alarm! Server $HOSTNAME failed connct to mysql service. I try to recover." > /dev/null
fi
unset command
unset chat_id
