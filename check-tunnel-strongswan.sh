#!/bin/bash
LOG=/var/log/messages
Remote=10.20.1.10 # ping zabbix-server
    ping -c 3 $Remote
    OK=$?
    if [ $OK -ne 0 ]; then
       echo "channel will be restarted" >> $LOG
       /usr/bin/systemctl restart strongswan
    fi

