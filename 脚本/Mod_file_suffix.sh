#!/bin/bash

#批量进行修改文件后缀名

open=$(date +%Y_%m_%d)

for file_name in $(find /opt/test/ -type f); do
    old_file_name=$(echo $file_name | awk -F. '{print $1}')
	suffix_name=$(echo $file_name | awk -F. '{print $2}')
	new_file_name=${old_file_name}_${open}.${suffix_name}
       mv $file_name $new_file_name
done
