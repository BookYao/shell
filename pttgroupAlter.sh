
#!/bin/sh

function altertable()
{
    let corpcount=$1
    local tablelist=`psql -U ompuser -d OMPDB -t -c "\dt" | cut -d '|' -f 2 | grep "T_PttGroup*" | xargs`
    psql -U ompuser -d OMPDB -t -c "set client_encoding=\"UTF-8\";"
    #echo $tablelist

    a=1
    for table in $tablelist
    do
        flag=`psql -U ompuser -d OMPDB -t -c "select count(*) from information_schema.columns where table_name='$table' and column_name='pg_gopen'"`
        if [ $flag -eq 1 ];then
            :
        else
            psql -U ompuser -d OMPDB -t -c "alter table \"$table\" add column pg_gopen int4 default 0" >> /dev/null
            echo "add field ok. table:$table"

            a=$(($a+1))
            if [ $a -gt $corpcount ];then
                break
            fi
        fi
    done
}

if [ $# != 1 ];then
    echo "Usage: $0 countCount"
    exit 0
fi

altertable $1
