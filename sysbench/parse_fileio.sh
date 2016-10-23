#!/bin/bash -e

test_name="fileio"

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
The result file should be named in this format: <limits>_<machine>_${test_name}_<opts>.prof (e.g. without_kv3_fileio_seqrewr.prof)

Usage: ./parse_${test_name}.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

mkdir -p $(dirname $3)

header="machine,limits,benchmark,base_result,lower_is_better,result"
if [ ! -f "$3" ] || ! grep -q "$header" "$3"; then
    echo "$header" | tee "$3"
fi

bn=`basename "$2" ".prof"`

res_test_name=`echo "$bn" | cut -d _ -f 3`
if [ "${res_test_name}" != "${test_name}" ]; then
    echo "Please check the if result file is from ${test_name} test. (Current test name: $res_test_name)"
    exit
fi

opts=`echo "$bn" | cut -d _ -f 4-`
machine=`echo "$bn" | cut -d _ -f 2`
limits=`echo "$bn" | cut -d _ -f 1`

p_opts_writes="writes/s:\s+\K[\d\.]+"

stats=('writes' 'fsyncs' 'written' 'total time:' 'total number of events:')

pt() {
    echo "${stats[$1]}\D+\K[\d\.]+"
}

for (( i=0; i<${#stats[@]}; i++ )); do
    base_res=`grep -oP "$(pt $i)"  $1`
    res=`grep -oP "$(pt $i)" $2`

    desc="${stats[i]}"

    if [ "${stats[i]}" == "total time:" ]; then
        (( ++i ))
        base_evs=`grep -oP "$(pt $i)" $1`
        evs=`grep -oP "$(pt $i)" $2`

        base_res=`echo "scale=4; ${base_evs}/${base_res}" | bc`
        res=`echo "scale=4; ${evs}/${res}" | bc`

        desc="event-fq"
    fi
    
    echo "$machine,$limits,sysbench_${test_name}_${opts}_${desc},$base_res,False,$res" | tee -a "$3"
done
