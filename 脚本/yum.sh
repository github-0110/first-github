#!/bin/bash

#配置本地yum源

# 备份yum源文件
mkdir /etc/yum.repos.d/all
mv /etc/yum.repos.d/*.repo  /etc/yum.repos.d/all

#挂在光盘
mount /dev/sr0 /mnt &> /dev/null

#创建存放yum的文件并编辑
touch /etc/yum.repos.d/centos.repo

cat << eof > /etc/yum.repos.d/centos.repo
[centos]
name=centos
baseurl=file:///mnt
enable=1
gpgcheck=0
eof

#查看可用源
yum clean all &> /dev/null
yum repolist




