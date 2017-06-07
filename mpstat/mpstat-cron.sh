#!/bin/bash
##################################
# Zabbix monitoring script
#
# Info:
#  - cron job to gather mpstat data
#  - can not do real time as mpstat data gathering will exceed 
#    Zabbix agent timeout
##################################
# Contact:
#  popexizhi@gmail.com
##################################
# ChangeLog:
#  20170607	initial creation
##################################

# source data file
DEST_DATA=/usr/local/zabbix-agent-ops/var/mpstat-data
TMP_DATA=/usr/local/zabbix-agent-ops/var/mpstat-data.tmp

#
# gather data in temp file first, then move to final location
# it avoids zabbix-agent to gather data from a half written source file
#
# mpstat -kx 10 2 - will display 2 lines :
#  - 1st: statistics since boot -- useless
#  - 2nd: statistics over the last 10 sec
#
mpstat -P ALL 10 1 > $TMP_DATA
mv $TMP_DATA $DEST_DATA
#echo `date +%T_%F`>>/usr/local/zabbix-agent-ops/var/log


