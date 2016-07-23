#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

p='^Nodes/second\s+:\s+\K[\d.]+'

base_res=`grep -oP "$p" "$1"`

res=`grep -oP "$p" "$2"`

mkdir -p $(dirname $3)

echo "stockfish-7,$base_res,False,$res" | tee -a "$3"
