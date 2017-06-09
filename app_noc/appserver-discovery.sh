#!/bin/bash
get_app(){
    #分析最后的更新log使用
    local PH_DIR=$1 # log的文件夹位置
    local pre_log="app_server_[0-9]*.log.txt*" #默认使用log的后缀
    local hostid_dev=$2
    filelist=`find ${PH_DIR} -maxdepth 1 -mtime -1 -name "${pre_log}"`
    count=`find ${PH_DIR} -maxdepth 1 -mtime -1 -name "${pre_log}"| wc -l`
    index=0

    echo '{"data":['
    for file in ${filelist}
    do
        hostid=`echo "${file}"|sed 's/.*\///g'|sed 's/\(app_server_\)\([0-9]*\).log.txt/\2/g'`
        echo -n '{"{#DEVNAME}":"'${hostid}'"}'
        echo "${hostid}" >>${hostid_dev}
        (( index+=1 ))
        if [ $index -lt $count ]; then
            echo ','
        fi
    done
    echo ']}'
}
applist="applist"
if [ -f ${applist} ]
then
    rm ${applist}
fi

get_app "/home/slim/beta_test/app_server_test" "${applist}" 

