#!/bin/bash
#

#判断是否有参数
if [ $# -eq 0 ]; then
	echo "帮助：$0 没有提供参数"
	exit 30
fi

case $1 in
	linux|Linux|LINUX)
	echo "红帽"
	;;
	Windows|windows|WINDOWS)
	echo "微软"
	;;
	Macos|MACOS|macos)
	echo "苹果"
	;;
	*)
	echo "其他"
esac

