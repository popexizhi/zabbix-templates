#!/bin/bash

DEVICES=`mpstat -P ALL 1 1 | awk '{ if ( $1 ~ "^[0-9]") { print $3} }'|grep -v CPU`

COUNT=`echo "$CPU" | wc -l`
INDEX=0
echo '{"data":['
echo "$DEVICES" | while read LINE; do
    echo -n '{"{#DEVNAME}":"'$LINE'"}'
    INDEX=`expr $INDEX + 1`
    if [ $INDEX -lt $COUNT ]; then
        echo ','
    fi
done
echo ']}'

