#!/bin/sh
file=/usr/local/asg/configs/system.conf
if [ ! -e $file ] 
then
    echo "Usage: Check whether $file exists"
    exit
fi

varrmq='\[MESSAGE\]'
flag=0
if ! grep  -q $varrmq $file 
then 
    echo -e "\n[MESSAGE]" >>$file
    flag=1
fi

arr_name=("WEB_PLATFORM_PATH" "MSG_PLATFORM_PHONE")
arr_val=("" "")

if [ $flag -eq 1 ]
then 
    for(( i=0;i<${#arr_name[@]};i++))
    do 
        echo "${arr_name[i]}=${arr_val[i]}" >>$file
    done 
fi 
echo "**************************************"
echo "modify $file complite!!!!"
echo "**************************************"
