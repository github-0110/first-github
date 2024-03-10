#!/bin/bash

#配置ssh免密登录


if [ -e ~/.ssh/id_rsa  ]; then
	rm -rf ~/.ssh/id_rsa*
fi

ssh-keygen -t rsa -f  ~/.ssh/id_rsa -P ""

if [ -e ~/.ssh/known_hosts ]; then
	> ~/.ssh/known_hosts
fi

/usr/bin/expect << eof
set timeout 3
spawn ssh-copy-id root@192.168.30.130
expect "(yes/no)?"
send "yes\n"
expect "root@192.168.30.130's password:"
send "0\n"
expect eof
eof



