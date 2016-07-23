#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

mkdir -p $(dirname $3)

test_list=('FL-POINT  Copy' 'FL-POINT  Scale' 'FL-POINT  Add' 'FL-POINT  Triad')

for test in "${test_list[@]}"; do
    pattern="^$test:\s+\K[\d+.]+"
    
    base_res=`grep -oP "$pattern" "$1"`
    res=`grep -oP "$pattern" "$2"`

    test_name=`echo "$test" | sed "s/[A-Z]/\l&/g" | sed "s/  /_/g"`
    echo "ramsmp_$test_name,$base_res,False,$res" | tee -a "$3"
done
