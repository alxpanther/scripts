#!/bin/sh

SERVICE_NAME="----------- name of service -----------"
NUM_OF_INSTANCE=4

NUM_OF_ACTIVE_NODES=`docker node ls |grep "Ready" | grep -v "Leader" | wc -l`

let NUM_OF_SCALE=$NUM_OF_ACTIVE_NODES*$NUM_OF_INSTANCE

docker service scale -d $SERVICE_NAME=$NUM_OF_SCALE
