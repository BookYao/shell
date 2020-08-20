

#
# 产生 20028130000 到 20018231000 之间的数字，
# 然后组合成 sip 注册的认证字符串 写入到 user.csv 文件，

# user.csv file format
# SEQUENTIAL
# 1000;[authentication username=1000 password=1000]
#

file=user.csv

echo "SEQUENTIAL" >> $file
count=20028130000
passwd=30000
for ((count=20028130000;count<20028131000;))
do
    echo "$count;[authentication username=$count password=$passwd]" >> $file
    count=`expr $count + 1`
    passwd=`expr $passwd + 1`
done

echo "make user.csv finish."
