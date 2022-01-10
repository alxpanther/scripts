#!/bin/bash

export PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/local/sbin

tail -F logs/maillog | sed 's/\\n550[- ]*5\.1\.1//g' | sed 's/\\n550[- ]*5\.7\.26//g' | sed 's/\\//g' | egrep -i --line-buffered ": 5" | xargs -d '\n' -IXXX ./search2telegram.sh XXX
