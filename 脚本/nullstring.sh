#!/bin/bash

#查看指定文件的空行数

read -p "文件名称" file

if grep "^$" $file &> /dev/null ;then
	echo "空行数为："
	grep "^$" $file | wc -l
	echo "空行所在的行数："
	grep -n "^$" $file
fi
