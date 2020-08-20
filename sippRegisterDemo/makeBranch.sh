
#!/bin/sh

file=batchBranch.sh


#
# 产生 20028130000 ~ 20028130001 之间的1000条 sipp 命令，做并发测试
#
for ((count=20028130000;count<20028131000;))
do
    echo "sipp -sf branchc.xml -inf $count.csv -i 192.168.50.132 -m 1 -trace_msg 10.0.0.47:7080 -aa -trace_err &" >> $file
    count=`expr $count + 1`
done

chmod 755 $file

echo "make batchBranch.sh finish"
