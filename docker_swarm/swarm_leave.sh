#!/bin/sh
/bin/docker swarm leave
sleep 5
/bin/docker swarm leave --force
sleep 2

