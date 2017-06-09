#!/bin/bash
#建立临时目录软连接
zabbix_ph="/usr/local/zabbix-agent-ops"
if [ ! -d ${zabbix_ph} ];
then
    echo "建立临时目录软连接"
    cur_dir=`pwd`
    sudo ln -s ${cur_dir} ${zabbix_ph}
    ls -all /usr/local/
    sudo mkdir ${zabbix_ph}/bin
    sudo chmod 777 ${zabbix_ph}/bin
    sudo mkdir ${zabbix_ph}/var
    sudo chmod 777 ${zabbix_ph}/var
fi
cp appserver-discovery.sh ${zabbix_ph}/bin/
cp appserver-check.sh ${zabbix_ph}/bin/

#增加自动运行到crontab -e
echo "增加自动运行到crontab "
sudo cp app-cron.conf /etc/cron.d/
ls -all /etc/cron.d/
ls -all ${zabbix_ph}/var/
echo "wait 60s..."
sleep 60
ls -all ${zabbix_ph}/var/
echo "crontab -e 自己加吧！这个/etc/cron.d不生效啊 :)..."
#设置zabbix-agentd端的运行参数
echo "设置zabbix-agentd端的运行参数"
sudo cp noc-params.conf /etc/zabbix/zabbix_agentd.conf.d/ 
ls  -all /etc/zabbix/zabbix_agentd.conf.d/

#重启zabbix_agentd
sudo service zabbix-agent restart
echo "1min 后 ，去zabbix的最新数据中找最新数据吧！good luck"
