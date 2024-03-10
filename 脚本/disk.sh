#!/bin/bash

#检测磁盘使用率

df -hT | awk '{print $7}'
# 获取磁盘名称
read -p "磁盘名称" disk_name

# 获取磁盘使用率
disk_usage=$(df -hT | grep "${disk_name}$"  | awk '{print $6}' | awk -F% '{print $1}')

# 判断磁盘使用率是否大于60%
if [ $disk_usage -gt 60 ]; then
    echo "磁盘${disk_name}容量使用率超过60%，警告!						磁盘已使用($(df -hT | grep "${disk_name}$"  | awk '{print $6}'))"
else
    echo "磁盘${disk_name}容量使用率正常"
fi

