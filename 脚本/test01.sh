#!/bin/bash

#检查文件是否存在

read -p "输入文件" file

if [ -e $file ] ;then
	echo "文件存在"
else
	echo "文件不存在"
fi
