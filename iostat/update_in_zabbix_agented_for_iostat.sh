#!/bin/bash
#建立临时目录软连接
echo "建立临时目录软连接"
cur_dir=`pwd`
sudo ln -s ${cur_dir} /usr/local/zabbix-agent-ops
ls -all /usr/local/

#增加自动运行到crontab -e
echo "增加自动运行到crontab "
sudo cp iostat-cron.conf /etc/cron.d/
ls -all /etc/cron.d/
ls -all var/
echo "wait 60s..."
sleep 60
ls -all var/
echo "crontab -e 自己加吧！这个/etc/cron.d不生效啊 :)..."
#设置zabbix-agentd端的运行参数
echo "设置zabbix-agentd端的运行参数"
sudo cp iostat-params.conf /etc/zabbix/zabbix_agentd.conf.d/ 
ls  -all /etc/zabbix/zabbix_agentd.conf.d/

#重启zabbix_agentd
sudo service zabbix-agent restart
echo "1min 后 ，去zabbix的最新数据中找最新数据吧！good luck"
