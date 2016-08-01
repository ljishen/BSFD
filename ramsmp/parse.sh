#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

bm_marks="1 2 4 5"
bm_mems="3 6"

bn=`basename "$1" ".prof"`
bm_id=`echo "$bn" | cut -d _ -f 3`

script_path=`dirname $(readlink -f $0)`

if [[ "$bm_mems" =~ "$bm_id" ]]; then
    $script_path/parse_mem.sh "$@"
elif [[ "$bm_marks" =~ "$bm_id" ]]; then
    $script_path/parse_mark.sh "$@"
else
    echo "Unsupported benchmark ID."
fi
