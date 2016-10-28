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

p='^Nodes/second\s+:\s+\K[\d\.]+'

base_res=`grep -oP "$p" "$1"`

res=`grep -oP "$p" "$2"`

echo "$machine,$limits,stockfish-7,$base_res,False,$res" | tee -a "$3"
