#!/bin/bash

#检测MySQLIO和SQL线程的状态

if [ -z $1 ];then  
	echo "help: 请选择 <IO|SQL>"
	exit 30
fi

	state=$(mysql -uroot -pWWW.1.com -e "show slave status\G" &> /dev/null)

	status=$( $state | grep "Slave_($1)_Running:" | awk '{print $2}')
if [ "$status" == "Yes" ]; then
  		echo 1
else
 		echo 0
fi
