#!/bin/bash

#简单创建用户

# 获取用户名
read -p "用户名：" name

# 检查用户是否存在
if id "$name" &>/dev/null; then
    echo "用户已经存在"
else
    read -p "请输入密码：" password
    useradd "$name"
    echo "$password" | passwd --stdin "$name" &>/dev/null
    echo "用户${name}创建成功，密码为${password}"
fi
