#!/bin/bash

#查看网段内正在使用的IP并显示它的MAC地址

net=$(ifconfig ens33 | grep "netmask" | awk '{print $2}' | awk -F. '{print $1"."$2"."$3}')

local_ip=$(ifconfig ens33 | grep "netmask" | awk '{print $2}')
local_mac=$(ifconfig ens33 | grep "ether" | awk '{print $2}')

	echo "本机IP: $local_ip  本机MAC: $local_mac"
	echo "--------------------------------------"

#进行arping
for ip in $(seq 254); do
{
#跳过本机IP
	if [ "$net$.ip == $local_ip" ]; then
		continue
	fi
    if arping $net.$ip -c 1 -w 1 &> /dev/null; then
        arp="arping $net$ip -c 1 -w 1"
        ip_address=$($arp | grep "reply from" | awk '{print $4}')
        mac_address=$($arp | grep "reply from" | awk '{print $5}')
        echo "IP地址为: $ip_address MAC地址为: $mac_address"
    fi
}&
done
wait

