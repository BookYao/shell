#!/bin/sh
file=/usr/local/asg/configs/system.conf
if [ ! -e $file ] 
then
    echo "Usage: Check whether $file exists"
    exit
fi

varrmq='\[RMQ\]'
flag=0
if ! grep  -q $varrmq $file 
then 
    echo -e "\n[RMQ]" >>$file
    flag=1
fi

arr_name=("OPENRMQSWITCH" "HOSTNAME" "PORT" "VHOST" "RMQUSER" "RMQPASSWD")
arr_val=("ON" "127.0.0.1" "5800" "vhostBasemq" "userbase" "userpasswd")

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
