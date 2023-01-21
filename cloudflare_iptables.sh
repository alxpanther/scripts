#!/bin/bash

#echo "iptables -N cloudflare"

iptables -F cloudflare

for IP in $(wget -q -O - https://www.cloudflare.com/ips-v4); do iptables -A cloudflare -s $IP -j ACCEPT; done
for IP in $(wget -q -O - https://www.cloudflare.com/ips-v6); do iptables -A cloudflare -s $IP -j ACCEPT; done

iptables -A cloudflare -j DROP
