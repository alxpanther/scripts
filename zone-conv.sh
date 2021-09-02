#!/bin/sh

# Converting direct to the reverse zone for BIND
# Created by Alexander Fedorko (alx69, alx@alx.kiev.ua) 2020-09-20

EXCLUDE=';|ptr|bip|btm|ns1|ns2|178\.158'
NAMED_FILE='update.named'

LSFILE=`cd /var/named; find . -maxdepth 1 -name "*.local" -type f|sed 's/\.\///g'`

rm ${NAMED_FILE}

for dns_file in ${LSFILE}; do

#cat /var/named/${dns_file} | egrep "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | egrep -vi ${EXCLUDE} | tr "." " "| awk -v var="$dns_file" '{print "add "$6"."$5"."$4"."$3".in-addr.arpa. 86400 IN PTR "$1"."var".\nsend"}' >> ${NAMED_FILE}
cat /var/named/${dns_file} | egrep "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | egrep -vi ${EXCLUDE} | tr "." " "| awk -v var="$dns_file" '{print "add "$9"."$8"."$7"."$6".in-addr.arpa. 86400 IN PTR "$1"."var".\nsend"}' >> ${NAMED_FILE}

done

`which nsupdate` -l ${NAMED_FILE}

sleep 2
`which rndc` sync -clean
