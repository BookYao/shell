
#!/bin/sh

 
#
#  generate actual cdr file From all cdrfile
#  actual cdr file: /tmp/cdrFileSet.txt
function makeQueryFile()
{
    echo `date` "$1" >> /tmp/11.txt
    startYMD=`echo "$1" | cut -d ',' -f6 | cut -d '_' -f1`
    startM=`echo $startYMD | cut -d '-' -f2`
    startD=`echo $startYMD | cut -d '-' -f3`

    endYMD=`echo "$1" | cut -d ',' -f7 | cut -d '_' -f1`
    endM=`echo $endYMD | cut -d '-' -f2`
    endD=`echo $endYMD | cut -d '-' -f3`

    intStartM=`expr $startM`
    intEndM=`expr $endM`

    intStartD=`expr $startD`
    intEndD=`expr $endD`

    echo $intStartM
    echo $intStartD
    echo $intEndM
    echo $intEndD
    
    monthArray=(0 31 29 31 30 31 30 31 31 30 31 30 31)

    if [ $intStartM -eq $intEndM ]; then
        echo "euqal"
        for (( day = $intStartD; day <= $intEndD; day++ ))
        do
            if [ $day -lt 10 ]; then
                cdrRecordFile="callrecord$intStartM"0"$day*.cdr"
                echo $cdrRecordFile >> /tmp/cdrFileSet.txt
            else
                cdrRecordFile="callrecord$intStartM$day*.cdr"
                echo $cdrRecordFile >> /tmp/cdrFileSet.txt
            fi
        done
    elif [ $intStartM -lt $intEndM ]; then
        for (( day = $intStartD; day <= ${monthArray[$intStartM]}; day++ ))
        do
            if [ $day -lt 10 ]; then
                cdrRecordFile="callrecord$intStartM"0"$day*.cdr"
                echo $cdrRecordFile >> /tmp/cdrFileSet.txt
            else
                cdrRecordFile="callrecord$intStartM$day*.cdr"
                echo $cdrRecordFile >> /tmp/cdrFileSet.txt
            fi
        done

        for (( day = 1; day <= $intEndD; day++ ))
        do
            if [ $day -lt 10 ]; then
                cdrRecordFile="callrecord$intEndM"0"$day*.cdr"
                echo $cdrRecordFile >> /tmp/cdrFileSet.txt
            else
                cdrRecordFile="callrecord$intEndM$day*.cdr"
                echo $cdrRecordFile >> /tmp/cdrFileSet.txt
            fi
        done
    fi
}


#
# result: callrecordxxx.cdr callrecordxxx.cdr .....
#
function getQueryFileName()
{
    if [ ! -f /tmp/cdrFileSet.txt ]; then
        echo "Not Found cdrFileSet.txt"
        return
    fi

    content=""
    while read line
    do
        content=$content" "$line
    done < /tmp/cdrFileSet.txt
    cdrFileSet=$content
}


#
# result: /var/asg/log/cdr/callrecordxxx.cdr /var/asg/log/cdr/callrecordxxx.cdr .....
#
function getQueryFilePath()
{
    arr=(${cdrFileSet// / })

    filePath=""
    for fileName in ${arr[@]}
    do
       filePath=$filePath" "/var/asg/log/cdr/$fileName
    done
    
    cdrFilePath="/tmp/cdrFilePath.txt"
    echo "make cdrFilePath.txt"
    cat $filePath >> $cdrFilePath
    
}

function calTotalNum()
{
    caller=`cat $1 | cut -d ',' -f2`
    callee=`cat $1 | cut -d ',' -f4`

    if [ -z $caller ]; then
        echo "caller is null" 
        if [ ! -z $callee ]; then
            # caller is NULL, callee Not Null
            totalNum=`cat /tmp/cdrFilePath.txt | cut -d ',' -f2 | grep $callee | wc -l`
        else
            # caller is NULL, callee is Null
            totalNum=`cat /tmp/cdrFilePath.txt | wc -l`
        fi
    else
        if [ -z $callee ]; then
            echo "caller Not Null, callee is NULL"
            # caller Not NULL, callee is NULL
            totalNum=`cat /tmp/cdrFilePath.txt | cut -d ',' -f1 | grep $caller | wc -l`
        else
            totalNum=`cat /tmp/cdrFilePath.txt | grep $caller\",\"$callee | wc -l` 
        fi
    fi
    
    echo "totalNum: $totalNum"
}

#
# main
# Usage: 0,13613626489,0,,0,2020-07-18_16:34:00,2020-07-21_16:34:00
# @para: callerMod,caller,calleeMod,callee,?,startTime,endTime,
# function: 从众多文件中,获取 StartTime 和 EndTime 的文件
# source file format: callrecordMMDDHH.cdr, 
# 比如: callrecord071818.cdr: 表示: 截至7月18号18点的记录文件



#
# 从众多的文件中，获取starttime和endtime之间的文件
# 保存到 /tmp/cdrFileSet.txt
#
makeQueryFile "$1"


# 拼接获取到的文件名到变量 $cdrFileSet
#
getQueryFileName


# 获取完整路径文件里面的记录内容到临时文件 /tmp/cdrFilePath.txt
# 文件完整路径为： /var/asg/log/cdr/callrecordxxxx.cdr
# 现在已经获取到了 starttime~endtime区间的文件内容了，可以开始做一些统计工作了
getQueryFilePath


# 比如统计主叫或者被叫的记录条数
calTotalNum "$1"


echo "Cal Finish!"

