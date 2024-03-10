#!/bin/bash

#检测文件差异性

for src_file in $(find /opt/bj -type f); do
    dest_file=${src_file/bj/sh}
    # 同名文件不存在
    if [ ! -e $dest_file ]; then
        echo "文件$src_file丢失"
    else
        # 检测数据差异 
        src_file_md5=$(md5sum $src_file | awk '{print $1}')
        dest_file_md5=$(md5sum $dest_file | awk '{print $1}')
        if [ "$src_file_md5" == "$dest_file_md5" ]; then
			echo "文件完整"
		else
            echo "源文件$src_file, 目的文件$dest_file数据不一致"
    		cp -f $src_file  $dest_file
  		fi

    fi
done
