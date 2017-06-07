#!/bin/bash
##################################
# Zabbix monitoring script
#
# mpstat:
#  - IO
#  - running / blocked processes
#  - swap in / out
#  - block in / out
#
# Info:
#  - vmstat -P ALL data are gathered via cron job
##################################
# Contact:
#  popexizhi@gmail.com
##################################
# ChangeLog:
#  20170607	init
##################################

# Zabbix requested parameter
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# source data file
SOURCE_DATA=/usr/local/zabbix-agent-ops/var/mpstat-data

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
device_count=$(grep -Ec "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
if [ $device_count -eq 0 ]; then
  echo $ERROR_WRONG_PARAM
  exit 1
fi

# 2nd grab the data from the source file
case $ZBX_REQ_DATA in
  %usr)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $2}';;
  %nice)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $3}';;
  %sys)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $4}';;
  %iowait)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $5}';;
  %irq)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $6}';;
  %soft)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $7}';;
  %steal)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $8}';;
  %guest)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $9}';;
  %gnice)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $10}';;
  %idle)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $11}';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0

