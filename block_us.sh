#!/bin/bash

COUNTRIES="us"

ipset -N block_us hash:net

for country in $COUNTRIES; do
  wget -O - http://www.ipdeny.com/ipblocks/data/aggregated/$country-aggregated.zone  2>/dev/null | while read ip; do
    ipset -A block_us $ip;
  done
done

# Create WHITELIST for Google IPs
ipset create whitelist_us hash:net family inet hashsize 4096 maxelem 65536

nslookup -q=TXT _netblocks.google.com 8.8.8.8|grep ip4 | sed 's/^.*spf1 //g' | sed 's/ ~all"//g' | tr -d 'ip4:' | tr ' ' '\n' | xargs -n1 -IXXX ipset add whitelist_us XXX
nslookup -q=TXT _netblocks3.google.com 8.8.8.8|grep ip4 | sed 's/^.*spf1 //g' | sed 's/ ~all"//g' | tr -d 'ip4:' | tr ' ' '\n' | xargs -n1 -IXXX ipset add whitelist_us XXX

ipset add whitelist_us 8.8.8.8
ipset add whitelist_us 8.8.4.4

#ipset add whitelist_us 172.217.32.0/20
#ipset add whitelist_us 66.102.0.0/20
#ipset add whitelist_us 35.191.0.0/16
#ipset add whitelist_us 66.249.80.0/20
#ipset add whitelist_us 130.211.0.0/22
#ipset add whitelist_us 172.217.160.0/20
#ipset add whitelist_us 209.85.128.0/17
#ipset add whitelist_us 108.177.96.0/19
#ipset add whitelist_us 72.14.192.0/18
#ipset add whitelist_us 172.217.0.0/19
#ipset add whitelist_us 216.58.192.0/19
#ipset add whitelist_us 108.177.8.0/21
#ipset add whitelist_us 172.217.192.0/19
#ipset add whitelist_us 74.125.0.0/16
#ipset add whitelist_us 173.194.0.0/16
#ipset add whitelist_us 35.190.247.0/24
#ipset add whitelist_us 64.233.160.0/19
#ipset add whitelist_us 216.239.32.0/19
#ipset add whitelist_us 172.217.128.0/19