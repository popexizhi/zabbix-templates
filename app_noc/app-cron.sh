#!/bin/bash

analysis_last_log(){
    #分析最后的更新log使用
    local PH_DIR=$1 # log的文件夹位置
    local pre_log="/app_server_[0-9]*.log.txt*" #默认使用log的后缀
    filelist=`find ${PH_DIR} -mtime -1|grep ${pre_log}`
    for file in ${filelist}
    do
        echo "${file}"
    done

}
test(){
    analysis_last_log "/home/slim/beta_test/app_server_test"
}
main(){
    echo "hi,main" 
}

test
