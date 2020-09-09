#! /bin/bash
function read_dir() {
	local dstpath="CVS"
	for file in `ls $1`
	do
		curfile=$1"/"$file
		if [ -d $curfile ]; then
			if [ $file = "CVS" ]; then
				#echo $curfile
				rm -rf $curfile
			else
 				read_dir $curfile
			fi
 		else
 			:    # Nothing to do
		fi
	done
} 

#
# main function
#
if [ $# != 1 ]; then
	echo "Usage: $0 dir"
	exit 0
fi

#
# 遍历当前目录及其子目录下 usage: ./travelDir.sh  .    
read_dir $1
