Template iostat
===============

Show `mpstat -P ALL` result in Zabbix, Use " Average " .

INSTALL
-------

Assume the Zabbix agent is setup

### Install Cron Job
Since the first output of sysstat is the statistics since boot time, we need to wait for a period (like 10 seconds) to get the result, which should be done through cron job, otherwise it'll surpass the zabbix agent's timeout.


### Install User Parameters

run ./update_in_zabbix_agented_for_iostat.sh

if $tmp is err, crontab -e add iostat-cron.sh runing

### Import Template

Import iostat-template.xml, and link it to a host.


CREDITS
-------

Some of the scripts are from https://github.com/zbal/zabbix.

