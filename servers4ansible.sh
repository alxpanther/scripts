#!/bin/bash
#
# Created by Alexander Fedorko (02.09.2020)
#

# for Ansible
cat /var/named/*.local | egrep -va '^;|PTR' |grep -a " A "|egrep -va '^ns1|^ns2'|tr "." " " | awk '{print $1"."$2"."$3"\t\tansible_host="$6"."$7"."$8"."$9}'
