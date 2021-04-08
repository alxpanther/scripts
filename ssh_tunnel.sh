#!/bin/bash

#command="/usr/bin/ssh -gfnNT -i ~/.ssh/id_remote_port_rsa -L 127.0.0.1:125:127.0.0.1:25 coinsbit-smtp@51.89.42.74"
command="/usr/bin/ssh -gfnNT -L 127.0.0.1:3306:127.0.0.1:3306 -p22159 root@157.90.80.16"
#chat_id=-444564692
chat_id=-1001196961332
if ! pgrep -f "$command" &>/dev/null; then
    $command
    /usr/bin/curl --connect-timeout 10 -s -X POST \
    https://api.telegram.org/bot1156279255:AAGv-to37g8V1LucCoiATFrMuGyPYf6pVEc/sendMessage \
    -d chat_id=$chat_id \
    -d text="Alarm! Server $HOSTNAME failed connct to mysql service. I try to recover." > /dev/null
fi
unset command
unset chat_id
