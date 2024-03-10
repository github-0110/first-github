#!/bin/bash

#启动,关闭,重启nginx


nginx_cmd=/usr/local/nginx/sbin/nginx
nginx_pid=/usr/local/nginx/logs/nginx.pid

#判断参数是否存在
if [ -z $1 ]; then
	echo "帮助：$0 [start|restart|stop|status|reload]"
	exit
fi

#存在进行执行
case $1 in
	start)
		$nginx_cmd
		if [ $? -eq 0 ];then
			echo "nginx 启动成功"
		fi
		;;

	stop)
		$nginx_cmd -s stop
			echo "nginx 已关闭"
		;;

	restart)
		$nginx_cmd -s stop
		sleep 2
		$nginx_cmd
		if [ $? -eq 0 ];then
            echo "nginx 重启成功"
        fi
		;;

	status)
		if [ -e $nginx_pid ]; then
			echo "nginx的PID:  $(cat $nginx_pid) 已启动"
			systemctl status $(cat $nginx_pid)
		else 	
			echo "nginx 没有启动"
		fi
		;;

	reload)
		kill -1 $(cat $nginx_pid )
		;;
	*)
		echo "帮助：$0 [start|restart|stop|status|reload]"
		;;
esac
