#!/bin/bash
#

for i in $(cat /tmp/user) do
	if [ id $i &> /dev/null" ]; then
		echo "用户$i 已存在"
	else
		useradd $i -s /sbin/nologin
		echo "用户$i 创建完成"
	fi

done
