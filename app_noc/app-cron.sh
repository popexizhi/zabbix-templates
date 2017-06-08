#!/bin/bash

analysis_last_log(){
    #分析最后的更新log使用
    local PH_DIR=$1 # log的文件夹位置
    local pre_log="/app_server_[0-9]*.log.txt*" #默认使用log的后缀
    filelist=`find ${PH_DIR} -mtime -1|grep ${pre_log}`
    datelab="0608/1415"
    hostid_tmp="tmp"
    for file in ${filelist}
    do
        echo "${file}"
        get_log "${file}" ${datelab} ${hostid_tmp}
    done

}

get_log(){
    #
    filepath=$1 #
    datelab=$2 #要过滤的时间段标准
    tmpfile=$3 #存储位置
    local epoll="EpollLoop Throughput statistic" #分钟级别
    local client_count="total online client count" #ue 数量 
    cat ${filepath}|grep "${epoll}"|grep "${datelab}">>${tmpfile}
    cat ${filepath}|grep "${client_count}"|grep "${datelab}">>${tmpfile}

}


test(){
    analysis_last_log "/home/slim/beta_test/app_server_test"
    #get_log "/home/slim/beta_test/app_server_test/app_server_12132.log.txt" "0608/1415" tmp
}
main(){
    echo "hi,main" 
}

test
