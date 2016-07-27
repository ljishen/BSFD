#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

mkdir -p $(dirname $3)

header="benchmark,base_result,lower_is_better,result"
if [ ! -f "$3" ] || ! grep -q "$header" "$3"; then
    echo "$header" | tee "$3"
fi

type=`grep -oP "^[A-Z\-]+ & [A-Z]+(?=\s+1 Kb block)" "$1"`

test_list=('1' '2' '4' '8' '16' '32' '64' '128' '256' '512' '1024' '2048' '4096' '8192'
           '16384' '32768')

for test in "${test_list[@]}"; do
    pattern=" $test Kb block: \K[\d\.]+"
    
    base_res=`grep -oP "$pattern" "$1"`
    res=`grep -oP "$pattern" "$2"`

    type_name=`echo "$type" | sed "s/[A-Z]/\l&/g" | sed "s/ & /_/g"`
    echo "ramsmp_${type_name}_${test}kb_block,$base_res,False,$res" | tee -a "$3"
done
