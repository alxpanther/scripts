#!/bin/sh

docker node ls |grep "Down"|awk '{print $1}'| xargs -n1 -IXXX docker node rm XXX
