#!/bin/bash

iptables -N cloudflare
ip6tables -N cloudflare

iptables -F cloudflare
ip6tables -F cloudflare

for IP in $(wget -q -O - https://www.cloudflare.com/ips-v4); do iptables -A cloudflare -s $IP -j ACCEPT; done
for IP in $(wget -q -O - https://www.cloudflare.com/ips-v6); do ip6tables -A cloudflare -s $IP -j ACCEPT; done

iptables -A cloudflare -j DROP
ip6tables -A cloudflare -j DROP
