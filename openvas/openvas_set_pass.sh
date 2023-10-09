#!/bin/sh

docker-compose -p greenbone-community-edition exec -u gvmd gvmd gvmd --user=admin --new-password=<password>
