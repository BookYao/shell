#!/bin/sh

# ¿¿¿¿erlang ¿ Rabbitmq¿¿¿¿¿ rabbitmq ¿¿¿¿¿¿¿¿¿¿
#
#
login=`id -un`
if [ $login"" != "root" ];then
    echo "Using root User Executed!!!"
    exit 0
fi
######¿¿erl¿¿
FILE_DIR=/var
erlang=/usr/local/
if [ ! -e $erlang/erlang/bin/erl ]
then
    tar zxf erlang.tar.gz
    mv erlang $erlang
    if [ ! -e /usr/bin/erl ]
    then
        ln -s $erlang/erlang/bin/erl  /usr/bin/erl
        echo "****************************************************"
        echo "*** Erlang installed Complete!!!***"
        echo "****************************************************"
    fi 
else 
    if [ ! -e /usr/bin/erl ]
    then
        ln -s $erlang/erlang/bin/erl  /usr/bin/erl
    fi 
    echo "****************************************************"
    echo "*** Erlang has been installed!!! ***"
    echo "****************************************************"
fi 

#----------------¿¿rabbitMQ-server-----------------------------------------------
function updateHosts(){
    hostName=$(hostname)
    local_ip="127.0.0.1"
    hostname_count=`cat /etc/hosts |grep ${hostName} | grep -c ${local_ip}`
    if [ $hostname_count -eq 0 ]; then
        sed -i 's/'${local_ip}'/&   asg/' /etc/hosts
        if [ $? -eq 0 ];then
            echo "${add_host} add Success" 
            return 0
        else 
            echo "${add_host} add Failed"
            return 1
        fi 
    else 
        return  0
    fi
    
}
if [ ! -e /usr/local/bin/socat ]; then
    tar -zxvf socat.tar.gz
    if [ $? -ne 0 ];then 
    echo "Error:socat Not exites"
    exit 0
    else 
        mv socat /usr/local/bin
    fi 

fi

##¿¿¿/etc/hosts¿¿¿hostname ¿ 127.0.0.1,¿¿rabbitmq ¿¿¿¿
updateHosts
if [ $? -ne 0 ];then
    exit 
fi 
function modifyport()
{
    
        file=`find /usr/lib -name rabbit.app`
        str=`grep tcp_listeners $file`
        tmp=`echo $str|cut -d ',' -f2`
        port=${tmp:2:4}
        sed -i "s/$port/$1/g" $file
}

res=`rpm -qa rabbitmq-server`
if [ $res"" = "" ] ;then

    rpm -ivh rabbitmq-server-3.7.17-1.el6.noarch.rpm  --nodeps
    cp /usr/share/doc/rabbitmq-server-3.7.17/rabbitmq.config.example  /etc/rabbitmq/rabbitmq.config
    modifyport 5800
fi 
ps -ef |grep rabbitmq-server |grep -v grep >/dev/null 
if [ $? -eq 0 ];then
    service rabbitmq-server stop
fi


service rabbitmq-server start >/dev/null 2>&1
if [ $? -ne 0 ]
    then
        echo "Error:start rabbitmq-server Failed" 
        exit 0
else 
        echo "rabbitmq-server start Success-------"
fi 
function checkuser_list(){
    username=$1
    rabbitmqctl list_users|grep $username >/dev/null 
    if [ $? -eq 0 ];then 
        return 0 #¿¿¿¿¿¿0
    else 
        return 1
    fi 
}
function checkhost_list(){
    vhost=$1
    rabbitmqctl list_vhosts|grep $vhost >/dev/null 
    if [ $? -eq 0 ];then 
        return 0 #¿¿¿¿¿¿0
    else 
        return 1
    fi 
}

rabbitmq-plugins enable rabbitmq_management >/dev/null 2>&1
rabbitmq-server -detached >/dev/null 2>&1

#¿¿RMQS¿user ¿ vhost
#checkhost_list vhost_xml
#if [ $? -ne 0 ];then
#    rabbitmqctl add_vhost vhost_xml >/dev/null 2>&1
#fi 

#checkuser_list xmluser #¿¿¿¿¿¿¿¿
#if [ $? -ne 0 ];then 
#    rabbitmqctl add_user xmluser xmlpasswd >/dev/null 2>&1
#    rabbitmqctl set_permissions -p "vhost_xml" xmluser ".*" ".*" ".*" >/dev/null 2>&1
#    rabbitmqctl set_user_tags xmluser administrator >/dev/null 2>&1
#fi 

#¿¿RMQS¿user ¿ vhost
checkhost_list vhostBasemq
if [ $? -ne 0 ];then
    rabbitmqctl add_vhost vhostBasemq >/dev/null 2>&1
fi 
checkuser_list baseuser #¿¿¿¿¿¿¿¿
if [ $? -ne 0 ];then 
    rabbitmqctl add_user baseuser basepasswd >/dev/null 2>&1
    rabbitmqctl set_permissions -p "vhostBasemq" baseuser ".*" ".*" ".*" >/dev/null 2>&1
    rabbitmqctl set_user_tags baseuser administrator >/dev/null 2>&1
fi 

#¿¿RMQS¿user ¿ vhost
#checkhost_list vhost_basemq
#if [ $? -ne 0 ];then
#    rabbitmqctl add_vhost vhost_basemq >/dev/null 2>&1
#fi 

#checkuser_list baseuser #¿¿¿¿¿¿¿¿
#if [ $? -ne 0 ];then 
#    rabbitmqctl add_user baseuser basepasswd >/dev/null 2>&1
#    rabbitmqctl set_permissions -p "vhost_basemq" baseuser ".*" ".*" ".*" >/dev/null 2>&1
#    rabbitmqctl set_user_tags baseuser administrator >/dev/null 2>&1
#fi 

