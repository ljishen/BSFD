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

p_w='^Final score for writes:\s+\K\d+'
p_r='^Final score for reads :\s+\K\d+'

base_res_w=`grep -oP "$p_w" "$1"`
base_res_r=`grep -oP "$p_r" "$1"`

res_w=`grep -oP "$p_w" "$2"`
res_r=`grep -oP "$p_r" "$2"`

echo "blogbench_writes,$base_res_w,False,$res_w" | tee -a "$3"
echo "blogbench_reads,$base_res_r,False,$res_r" | tee -a "$3"
