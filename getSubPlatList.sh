
#!/bin/sh

if [ $# != 1 ];then
    echo "Usage: $0 subPlatformID"
    exit 1
fi

echo "======================"
echo "Input SubPlatformID is: $1"
echo "======================"

if [ -e /usr/local/pgsql/bin/psql ];then
    sqlcmd=/usr/local/pgsql/bin/psql
else
    echo "Pgsql database not install, Please check!!"
    exit 1
fi

if [ -e /usr/local/asg/bin/asgSimpleCmd ];then
    asgcmd=/usr/local/asg/bin/asgSimpleCmd
else
    echo "MDS-Server not install, Please check!!"
    exit 1
fi

echo "Get SubPlatform list. Please wait for a moment!"

$sqlcmd -U mdsuser -d MDSDB -c  "set client_encoding = "UTF-8";delete from gb_catalog_info; delete from gb_catalog_record where device_id='$1';" >/dev/null

$asgcmd "send_catalog_message $1"

sleep 3


echo "Get SubPlatform is finish."
