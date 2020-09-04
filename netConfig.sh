#!/bin/sh
netConf=`ls /etc/sysconfig/network-scripts/ifcfg-en* | head -n1`


if [ $netConf ];then
    mv $netConf /etc/sysconfig/network-scripts/ifcfg-eth0
    echo "finish copy configure file ifcfg-en* to eth0"
else
    echo "Not find net configure file ifcfg-en*"
    exit 1
fi


if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ];then
    sed -i 's/NAME=en.*/NAME=eth0/g' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/DEVICE=en.*/DEVICE=eth0/g' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/IPV6INIT=yes/IPV6INIT=no/g' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
fi


if [ -f /etc/default/grub ];then
    if ! cat /etc/default/grub | grep -q biosdevname;then
        echo "not find bios, need add ifnames, biosdevname"
        sed -i 's/rhgb/rhgb ipv6.disable=1 net.ifnames=0 biosdevname=0/g' /etc/default/grub
        grub2-mkconfig -o /boot/grub2/grub.cfg > /dev/null 2>&1
    fi
fi


if [ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ];then
    echo IPADDR=192.168.0.100 >> /etc/sysconfig/network-scripts/ifcfg-eth0
    echo NETMASK=255.255.255.0 >> /etc/sysconfig/network-scripts/ifcfg-eth0
    echo GATEWAY=192.168.0.254 >> /etc/sysconfig/network-scripts/ifcfg-eth0
fi
echo Net Configure is Successful
echo System Will Reboot, Please wait for a moment
sleep 5
reboot


