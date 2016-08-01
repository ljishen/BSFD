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

write_results() {
    declare -a test_list=("${!1}")
    for test in "${test_list[@]}"; do
        local pattern="^$test.+?\K[\d\.]+(?= $2)"

        local base_res=`grep -oP "$pattern" "$4"`
        local res=`grep -oP "$pattern" "$5"`

        local test_name=`echo "$test" | sed "s/ total//g" | sed "s/ /_/g"`
        echo "$machine,$limits,compilebench_$test_name,$base_res,$3,$res" | tee -a "$6"
    done
}

test_list_mbs=('intial create total' 'create total' 'patch total' 'compile total'
          'clean total' 'read tree total' 'read compiled tree total')
write_results test_list_mbs[@] "MB/s" "False" "$1" "$2" "$3"

test_list_sec=('delete tree total' 'stat tree total' 'stat compiled tree total')
write_results test_list_sec[@] "seconds" "True" "$1" "$2" "$3"
