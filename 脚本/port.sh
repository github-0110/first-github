#!/bin/bash

#查看端口


# 获取端口号
read -p "请输入端口号: " port

netstat -tunlp | grep :${port} &> /dev/null

# 判断端口号是否存在
if [ $? -eq 0 ]; then
port_name=$(netstat -tunlp | grep ':3306' | awk  '{print $NF}' | awk -F/ '{print $2}') | uniq
port_id=$(netstat -tunlp | grep ':3306' | awk  '{print $NF}' | awk -F/ '{print $1}') | uniq
	 echo "端口号：$port	进程名称：$port_name	进程ID: $port_id" 
else
    echo "端口不存在"
fi

