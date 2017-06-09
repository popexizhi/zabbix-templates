#!/bin/bash
##################################
# Zabbix monitoring script
# Info:
#  - appserver   data are gathered via cron job
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# source data file
SOURCE_DATA=/usr/local/zabbix-agent-ops/var/tmp_app_$1

#
# Error handling:
#  - need to be displayable in Zabbix (avoid NOT_SUPPORTED)
#  - items need to be of type "float" (allow negative + float)
#
ERROR_NO_DATA_FILE="-0.9900"
ERROR_OLD_DATA="-0.9901"
ERROR_WRONG_PARAM="-0.9902"
ERROR_MISSING_PARAM="-0.9903"

# No data file to read from
if [ ! -f "$SOURCE_DATA" ]; then
  echo $ERROR_NO_DATA_FILE 
  exit 1
fi

# Missing device to get data from
if [ -z "$ZBX_REQ_DATA_DEV" ]; then
  echo $ERROR_MISSING_PARAM
  exit 1
fi

#
# Old data handling:
#  - in case the cron can not update the data file
#  - in case the data are too old we want to notify the system
# Consider the data as non-valid if older than OLD_DATA minutes
#
OLD_DATA=5
if [ $(stat -c "%Y" $SOURCE_DATA) -lt $(date -d "now -$OLD_DATA min" "+%s" ) ]; then
  echo $ERROR_OLD_DATA
  exit 1
fi

# 
# Grab data from SOURCE_DATA for key ZBX_REQ_DATA
#
# 1st check the device exists and gets data gathered by cron job
#device_count=$(grep -Ec "$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
#if [ $device_count -eq 0 ]; then
#  echo $ERROR_WRONG_PARAM
#  exit 1
#fi

# 2nd grab the data from the source file
case $ZBX_REQ_DATA in
  epoll_sent)       
        sent=`cat $SOURCE_DATA|grep "EpollLoop Throughput"|sed 's/.*sent=//g'|sed 's/(kb.*//g'`
        echo ${sent};;
  epoll_read)
        read=`cat $SOURCE_DATA|grep "EpollLoop Throughput"|sed 's/.*read=//g'|sed 's/(kb.*//g'`
        echo ${read};;
  total_client)
        total_client=`cat $SOURCE_DATA|tail -n 1|grep total|sed 's/.*total online client count: //g'|sed 's/ connected client:.*//g'`
        echo ${total_client};;
  connect_client)
        connect_client=`cat $SOURCE_DATA|tail -n 1|grep total|sed 's/.*connected client: //g'`
        echo ${connect_client};;

  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0

