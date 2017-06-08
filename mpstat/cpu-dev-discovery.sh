#!/bin/bash

DEVICES=`mpstat -P ALL |grep -v CPU|awk '{ if ( $1 ~ "^[0-9]") { print $2 } }'` #debug log显示zabbix执行结果中没有CST，next :改进此脚本

COUNT=`echo "$DEVICES" | wc -l`
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

