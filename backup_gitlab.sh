#!/bin/bash

# Created by Alexander Fedorko (alx69, alx69@ukr.net) 2020-09-20

export PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/local/sbin

date_backup=`date +"%d-%m-%Y"`

BOT_TOKEN="XXXXX" # Telegram Bot ID
CHAT_ID="XXXX"    # Telegram Chat ID

#SSH_COMMAND="`which ssh` -p 22001"
SSH_COMMAND="`which ssh`"
RSYNC_COMMAND=`which rsync`

SRC_GITLAB_DIR="/var/opt/gitlab/backups"
SRC="/etc/gitlab/gitlab-secrets.json /etc/gitlab/gitlab.rb"

# !!! CHANGE THIS !!!!
DST_HOST="gitlab@A.B.C.D"
DST_DIR="/home/gitlab/backups/gitlab"

DST="${DST_HOST}:${DST_DIR}/${date_backup}/"
LOG="/var/log/backup.log"
LOG_RSYNC="tlg.txt"

# ------ Start Backup ------
echo `date +%F_%H:%M:%S`": Backup started `date` to ${DST}" >> ${LOG}

#gitlab-backup create GZIP_RSYNCABLE=yes SKIP=registry,artifacts
gitlab-backup create GZIP_RSYNCABLE=yes BACKUP=dump SKIP=registry,artifacts
cd ${SRC_GITLAB_DIR}
gzip -9 dump_gitlab_backup.tar

wi=0
while [ $wi -lt 10 ]
do
    wi=$((wi+1))
    ${RSYNC_COMMAND} -aHv -e "${SSH_COMMAND}" ${SRC_GITLAB_DIR}/dump_gitlab_backup* ${SRC} ${DST} >> ${LOG_RSYNC} 2>&1
    if [ "$?" = "0" ] ; then
        cat ${LOG_RSYNC} >> ${LOG}
        LOG_TO_TELEGRAM=`cat ${LOG_RSYNC}`
        echo ${LOG_TO_TELEGRAM}

        echo "Rsync completed normally" >> ${LOG}
        break
    else
        echo `date +%F_%H:%M:%S`": Rsync failure. Backing off and retrying...(attempt - $wi)" >> ${LOG}
        sleep 30
    fi
done


echo `date +%F_%H:%M:%S`": Find and delete OLD backups" >> ${LOG}
${SSH_COMMAND} ${DST_HOST} "find ${DST_DIR} -maxdepth 1 -mtime +8 -type d -exec rm -rv {} \;"
echo `date +%F_%H:%M:%S`": Backup finished `date` to ${DST}" >> ${LOG}
echo "------" >> ${LOG}
echo "" >> ${LOG}

rm ${SRC_GITLAB_DIR}/dump_gitlab_backup.tar.gz ${SRC_GITLAB_DIR}/${LOG_RSYNC}

/usr/bin/curl --connect-timeout 10 -s -X POST \
 https://api.telegram.org/${BOT_TOKEN}/sendMessage \
 -d chat_id=${CHAT_ID} \
 -d text="Backup GitLab (${date_backup}): ${LOG_TO_TELEGRAM}" > /dev/null
