#!/bin/bash

# 定义虚拟机配置文件和镜像文件的路径
base_config_file=/data/template.xml
base_disk_file=/data/template.qcow2

# 创建单个虚拟机
create_single_vm() {
    read -p "温馨提示:请以centos开头
请输入创建虚拟机名称:" name

    # 检查虚拟机是否存在
    if virsh list --all | grep -q $name; then
        echo "虚拟机$name已经存在。请重新输入。"
        return 1
    fi

    # 创建虚拟机
    vm_name=$name
    disk_name=/var/lib/libvirt/images/${vm_name}.qcow2
    vm_uuid=$(uuidgen)
    mac_address=52:54:00:$(openssl rand -hex 10 | sed -r 's/(..)(..)(..).*/\1:\2:\3/')

    # 复制虚拟机配置文件
    cp $base_config_file /etc/libvirt/qemu/${vm_name}.xml

    # 创建虚拟机镜像
    qemu-img create -f qcow2 -b $base_disk_file $disk_name

    # 编辑虚拟机配置文件
    sed -i "s/base_name/$vm_name/" /etc/libvirt/qemu/${vm_name}.xml
    sed -i "/uuid/c \  <uuid>$vm_uuid</uuid>" /etc/libvirt/qemu/${vm_name}.xml
    sed -i "/<mac/c \      <mac address='$mac_address'/>" /etc/libvirt/qemu/${vm_name}.xml

    # 导入虚拟机
    virsh define /etc/libvirt/qemu/${vm_name}.xml
}

# 创建多个虚拟机
create_multiple_vms() {
    read -p "请输入创建虚拟机数量: " number

    # 检查虚拟机数量是否为正数
    if [ $number -le 0 ]; then
        echo "虚拟机数量必须为正数。请重新输入。"
        return 1
    fi

    # 删除所有名为“centos”的虚拟机
    ids=$(virsh list --all | awk "/centos/{print \$2}")
    if [ -n "$ids" ]; then
        for id in $ids; do
            virsh destroy $id
            virsh undefine $id
        done
        rm -rf /var/lib/libvirt/images/*
    fi

    # 创建多个虚拟机
    for i in $(seq $number); do
        vm_name=vm${i}_centos79
        disk_name=/var/lib/libvirt/images/${vm_name}.qcow2
        vm_uuid=$(uuidgen)
        mac_address=52:54:00:$(openssl rand -hex 10 | sed -r 's/(..)(..)(..).*/\1:\2:\3/')

        # 复制虚拟机配置文件
        cp $base_config_file /etc/libvirt/qemu/${vm_name}.xml

        # 创建虚拟机镜像
        qemu-img create -f qcow2 -b $base_disk_file $disk_name

        # 编辑虚拟机配置文件
        sed -i "s/base_name/$vm_name/" /etc/libvirt/qemu/${vm_name}.xml
        sed -i "/uuid/c \  <uuid>$vm_uuid</uuid>" /etc/libvirt/qemu/${vm_name}.xml
        sed -i "/<mac/c \      <mac address='$mac_address'/>" /etc/libvirt/qemu/${vm_name}.xml

        # 导入虚拟机
        virsh define /etc/libvirt/qemu/${vm_name}.xml
    done
}

# 删除单个虚拟机
delete_single_vm() {
    virsh list --all
    read -p "请输入删除虚拟机名称: " name

    # 检查虚拟机是否存在
    if ! virsh list --all | grep -q $name; then
        echo "虚拟机$name不存在。请重新输入。"
        return 1
    fi

    # 检查虚拟机是否正在运行
    if virsh domstate $name | grep -q running; then
        echo "虚拟机$name正在运行。请停止它后再删除。"
        return 1
    fi

    # 删除虚拟机
    virsh destroy $name
    virsh undefine $name
    rm -rf /var/lib/libvirt/images/${name}.qcow2
}

# 删除所有虚拟机
delete_all_vms() {
    for i in $(virsh list --all | awk "/centos/{print $2}");
    do
        virsh destroy $i &> /dev/null
        virsh undefine $i &> /dev/null
    done
    rm -rf /var/lib/libvirt/images/*
    echo "已删除所有虚拟机"
}

#查看所有虚拟机
listall() {
    virsh list --all
}

#启动虚拟机
startkvm() {
    virsh list --all
    read -p "请输入启动虚拟机名称: " name
    virsh start ${name}
    echo "虚拟机${name}启动成功"
}

#创建菜单
cat << EOF
========虚拟机管理工具========
|   1.查看已存在的虚拟机     | 
|   2.创建虚拟机(单个)       |
|   3.创建虚拟机(多个)       |
|   4.删除虚拟机(单个)       |
|   5.删除虚拟机(全部)       |
|   6.启动虚拟机             |
|   7.退出                   |
========虚拟机管理工具========
EOF
echo

    while true; do
        read -p "请选择操作--> " choice
        case $choice in
            1)
                listall
                ;;
            2)
                create_single_vm
                ;;
            3)
                create_multiple_vms
                ;;
            4)
                delete_single_vm
                ;;
            5)
                delete_all_vms
                ;;
            6)  
                startkvm
                ;;

	    7)  exit
                ;;

            *)
                echo "无效的选择。请重新选择。"
                ;;
        esac
    done
