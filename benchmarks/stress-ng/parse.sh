#!/bin/bash

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
The result file should be named in this format: <limits>_<machine>_<stressor-class>.prof

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
stressor_class=`echo "$bn" | cut -d _ -f 3`
machine=`echo "$bn" | cut -d _ -f 2`
limits=`echo "$bn" | cut -d _ -f 1`

p_name='stressor: \K.+$'

base_res_names=(`grep -oP "$p_name" "$1"`)

for stressor in "${base_res_names[@]}"; do
    res_name=`grep "stressor: ${stressor}$" "$2"`
    if [ -n "$res_name" ]; then # $res_name is not null
        base_res_time=`grep -A3 "stressor: ${stressor}$" "$1" | grep -oP "real-time: \K[\d\.]+"`
        res_time=`grep -A3 "stressor: ${stressor}$" "$2" | grep -oP "real-time: \K[\d\.]+"`

        echo "$machine,$limits,stress-ng_${stressor_class}_${stressor},$base_res_time,False,$res_time" | tee -a "$3"
    else
        echo "WARNING: stressor: ${stressor} is not in the result file."
    fi
done
