#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

mkdir -p $(dirname $3)

header="machine,limits,benchmark,base_result,lower_is_better,result"
if [ ! -f "$3" ] || ! grep -q "$header" "$3"; then
    echo "$header" | tee "$3"
fi

bn=`basename "$2" ".prof"`
machine=`echo "$bn" | cut -d _ -f 2`
limits=`echo "$bn" | cut -d _ -f 1`

test_list=('NUMERIC SORT' 'STRING SORT' 'BITFIELD' 'FP EMULATION' 'FOURIER' 'ASSIGNMENT'
           'IDEA' 'HUFFMAN' 'NEURAL NET' 'LU DECOMPOSITION' 'MEMORY INDEX' 'INTEGER INDEX'
           'FLOATING-POINT INDEX')

for test in "${test_list[@]}"; do
    pattern="^$test\s*:\s+\K[\d\.]+"
    
    base_res=(`grep -oP "$pattern" "$1"`)
    res=(`grep -oP "$pattern" "$2"`)

    test_name=`echo "$test" | sed "s/[A-Z]/\l&/g" | sed "s/ /_/g"`
    index=0
    if [ "$test" == "FLOATING-POINT INDEX" ] || [ "$test" == "INTEGER INDEX" ]; then
        index=1
    fi
    echo "$machine,$limits,nbench_$test_name,${base_res[$index]},False,${res[$index]}" | tee -a "$3"
done
