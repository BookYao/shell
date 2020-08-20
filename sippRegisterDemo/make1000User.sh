

#
# 产生 20028130000 到 20018231000 之间的1000个user.csv 文件，
# 然后用 1000个 脚本命令同时读取1000个user.csv 文件，做并发测试

# user.csv file format
# SEQUENTIAL
# 1000;[authentication username=1000 password=1000]
#


count=20028130000
passwd=30000

for ((count=20028130000;count<20028131000;))
do
    echo "SEQUENTIAL" >> $count.csv
    echo "$count;[authentication username=$count password=$passwd]" >> $count.csv
    count=`expr $count + 1`
    passwd=`expr $passwd + 1`
done

echo "make 1000 user.csv finish."
