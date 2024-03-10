#!/bin/bash
#

read -p "输入系统:" system

if [ "$system" == 'linux' -o "$system" == 'Linux' -o "$system" == 'LINUX' ]; then
	echo "红帽"

  elif [ "$system" == 'windows' -o "$system" == 'Windows' -o "$system" == 'WINDOWS' ]; then
	echo "微软"

  elif [ $system == 'macos' -o $system == 'Macos' -o $system == 'MACOS' ]; then
    echo "苹果"

else 
	echo "其他"
fi


