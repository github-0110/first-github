#!/bin/bash

#----------系统初始化(最小化)----------

#永久关闭防火墙
  systemctl disable --now firewalld

#永久关闭selinux
  sed -i 's/SELINUX=enforcing/SELINUX=disabled/g'  /etc/selinux/config

#使用yun下载常用的软件
  yum install -y vim net-tools psmisc lftp wget bash-completion unzip tree tcpdump ntpdate


#配置固定IP
  ip=$(ip a s ens33 | grep 'inet ' | awk '{print $2}' | awk -F/ '{print $1}')
  netmask=24
  gateway=$(route -n | grep '^0.0.0.0' | awk '{print $2}')
  nmcli connection modify ens33 ipv4.addresses $ip/$netmask
  nmcli connection modify ens33 ipv4.gateway $gateway
  nmcli connection modify ens33 ipv4.dns 114.114.114.114
  nmcli connection reload
  nmcli connection up ens33

  sed -i '/BOOTPROTO/c \BOOTPROTO=none' /etc/sysconfig/network-scripts/ifcfg-ens33
#配置华为yum源
  cp -a /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
  wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.huaweicloud.com/repository/conf/CentOS-7-anon.repo
  yum clean all
  yum makecache

#每隔半小时进行时间同步
  echo "30 * * * *  /usr/sbin/ntpdate ntp.aliyun.com" >>  /etc/crontab

#修改ssh配置

  #关闭DNS反解
	sed -i '/UseDNS/c \UseDNS no' /etc/ssh/sshd_config


