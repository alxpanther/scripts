#!/bin/bash

# Created by Alexander Fedorko (alx69, alx69@ukr.net) 2020-09-20

export PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/local/sbin

date_backup=`date +"%d-%m-%Y"`

SSH_COMMAND="`which ssh` -p 22001"

SRC="/opt/backups/"

# !!! CHANGE THIS !!!
DST_HOST="devops-2@A.B.C.D"
DST_DIR="/home/devops/backups/site/"

DST="${DST_HOST}:${DST_DIR}/${date_backup}/"
LOG="/var/log/backup.log"

# ----

SITES_BACKUP_NAME="site-"
SITES_SRC=( /home/gitlab-runner/builds/XXX/0/XXX-dev/XXX-front /home/php-dev-3/XXX-back )

MYSQL_USER="root"
MYSQL_PASS=""
MYSQL_HOST="localhost"
MYSQL_BACKUP_NAME="XXX_base-"
MYSQL_BACKUP_PATH="/opt/backups/"
MYSQL_BASES=( XXXX )   # ( example1 example2 etc )
MYSQLDUMP_WHERE=`which mysqldump`
#MYSQLDUMP_STR="${MYSQLDUMP_WHERE} -h ${MYSQL_HOST} -u ${MYSQL_USER} --password=${MYSQL_PASS}"
MYSQLDUMP_STR="${MYSQLDUMP_WHERE} -h ${MYSQL_HOST} -u ${MYSQL_USER}"
GZIP_STR=`which gzip`
TAR_STR=`which tar`

# ------ Start Backup ------

mkdir -p ${MYSQL_BACKUP_PATH}

# Backup MySQL Bases
for i in "${MYSQL_BASES[@]}"
  do
    DATE_SE=`date +%F_%H:%M:%S`

    echo -n "${DATE_SE}: Archiving to temp dir base: $i ..." >> ${LOG}
    ${MYSQLDUMP_STR} --extended-insert=FALSE --lock-tables=FALSE -d -B --events --routines --triggers $i | gzip > ${MYSQL_BACKUP_PATH}/${MYSQL_BACKUP_NAME}$i"_"${date_backup}.sql.gz
    echo "done" >> ${LOG}
done

# Backup Sites
for s in "${SITES_SRC[@]}"
  do
    DATE_SE=`date +%F_%H:%M:%S`

    back_name=`echo $s | awk -F"/" '{print $NF}'`
    uniq_time=`date +%F_%H%M%S`
    echo -n "${DATE_SE}: Archiving to temp dir with site: $s ..." >> ${LOG}
    ${TAR_STR} czf ${MYSQL_BACKUP_PATH}/${SITES_BACKUP_NAME}${back_name}_${uniq_time}.tgz ${s}  >/dev/null 2>&1
    echo "done" >> ${LOG}
done

# ------ Start Transfer to Backup Server -------

echo `date +%F_%H:%M:%S`": Backup started `date` to ${DST}" >> ${LOG}
#/bin/rsync -aHvR --bwlimit=3000 --delete --exclude='sess_*' --delete-excluded ${SRC} ${DST} >> ${LOG}
`which rsync` -aHv -e "${SSH_COMMAND}" ${SRC} ${DST} >> ${LOG}
echo `date +%F_%H:%M:%S`": Find and delete OLD backups" >> ${LOG}
${SSH_COMMAND} ${DST_HOST} "find ${DST_DIR} -maxdepth 1 -mtime +14 -type d -exec rm -rv {} \;"
echo `date +%F_%H:%M:%S`": Backup finished `date` to ${DST}" >> ${LOG}
echo "------" >> ${LOG}
echo "" >> ${LOG}

rm ${SRC}/*
