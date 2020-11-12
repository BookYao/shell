#!/bin/sh
# bind 127.0.0.1  bind 127.0.0.1
# requirepass foobared  requirepass 123456

#old ip
oip="# bind 127.0.0.1"
#new
nip="bind 127.0.0.1"
#old 
opass="# requirepass foobared"
#new
npass="requirepass 123456"

configpath="/usr/local/redis/"
configfile="/usr/local/redis/redis.conf"
#backup file suffix
bs="20201105"

#redis config
if [ ! -e $configfile ]; then
	echo "redis.conf is not exist"
	exit
else
	cp $configfile $configfile.$bs

	cat $configfile | grep "$oip" > /dev/null
	if [ $? -eq 0  ]; then
		sed -i "s/$oip/$nip/g" $configfile
	fi

	cat $configfile | grep "$opass" > /dev/null
	if [ $? -eq 0 ]; then
		sed -i "s/$opass/$npass/g" $configfile
	fi

	#��������
	/usr/local/redis/redis-cli shutdown 

	#��������
	/usr/local/redis/redis-server /usr/local/redis/redis.conf

	#��������
	sleep 5
	/usr/local/redis/redis-cli -a 123456 shutdown
	echo "redis config updated!"
fi