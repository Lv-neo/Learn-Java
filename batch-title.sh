#!/bin/sh

function readfile ()
{
#这里`为esc下面的按键符号
  for file in `ls $1`
  do
#这里的-d表示是一个directory，即目录/子文件夹
    if [ -d $1"/"$file ]
    then
#如果子文件夹则递归
      readfile $1"/"$file
    else
#否则就能够读取该文件的地址
      if [ ${file##*.} == 'md' ]
      then
        echo $1"/"$file
        updateTitle $1"/"$file
        rm -f $1"/"$file"1"
      fi
#读取该文件的文件名，basename是提取文件名的关键字
#    echo `basename $file`
   fi
  done
}

function updateTitle() {
    sed -i 1 '1s/^#\(.*\)/---\
title: \1\
tag: java\
---\
<!-- toc -->\
# \1/' $1
}

folder="./source/_posts"
readfile $folder