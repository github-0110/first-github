#!/bin/bash

#批量进行修改文件后缀名

for file_name in $(find /opt/test/ -name "*.txt"); do
       new_file_name=${file_name/txt/jpg}
       mv $file_name $new_file_name
done
