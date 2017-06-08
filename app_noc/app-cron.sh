#!/bin/bash

analysis_last_log(){
    #分析最后的更新log使用
    local PH_DIR=$1 # log的文件夹位置
    local pre_log="/app_server_[0-9]*.log.txt*" #默认使用log的后缀
    local hostid_tmp=$2
    filelist=`find ${PH_DIR} -mtime -1|grep ${pre_log}`
    datelab=`date -d "-1 min" +%m%d/%H%M` #过滤前一分钟的数据
    echo "[`date +%H%M`]${datelab}"
    
    for file in ${filelist}
    do
        hostid=`echo "${file}"|sed 's/.*\///g'|sed 's/\(app_server_\)\([0-9]*\).log.txt/\2/g'`
        get_log "${file}" ${datelab} ${hostid_tmp} ${hostid}
    done

}

get_log(){
    #
    filepath=$1 #
    datelab=$2 #要过滤的时间段标准
    tmpfile=$3 #存储位置
    loglab=$4 #来源log标识,当前使用appserver的log名称中的hostid
    local epoll="EpollLoop Throughput statistic" #分钟级别
    local client_count="total online client count" #ue 数量 
    #过滤的原始文件
    cat ${filepath}|grep "${epoll}"|grep "${datelab}">>${tmpfile}_${loglab}.tmp
    cat ${filepath}|grep "${client_count}"|grep "${datelab}">>${tmpfile}_${loglab}.tmp

    mv ${tmpfile}_${loglab}.tmp ${tmpfile}_${loglab}

}


test(){
    analysis_last_log "/home/slim/beta_test/app_server_test" "tmp"
    #get_log "/home/slim/beta_test/app_server_test/app_server_12132.log.txt" "0608/1415" tmp
}
main(){
    #echo "hi,main" 
    analysis_last_log "/home/slim/beta_test/app_server_test" "/usr/local/zabbix-agent-ops/var/tmp_app"
}

#test
main
