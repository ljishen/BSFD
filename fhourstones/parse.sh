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

generatePattern() {
    echo "(?s)Solving $1\-ply.*?\K[\d\.]+(?= Kpos/sec)";
}

p_8=`generatePattern 8`
p_0=`generatePattern 0`

base_res_8s=(`grep -ozP "$p_8" "$1"`)
base_res_0=`grep -ozP "$p_0" "$1"`

res_8s=(`grep -ozP "$p_8" "$2"`)
res_0=`grep -ozP "$p_0" "$2"`

echo "$machine,$limits,fhourstones_8_1,${base_res_8s[0]},False,${res_8s[0]}" | tee -a "$3"
echo "$machine,$limits,fhourstones_8_2,${base_res_8s[1]},False,${res_8s[1]}" | tee -a "$3"
echo "$machine,$limits,fhourstones_8_3,${base_res_8s[2]},False,${res_8s[2]}" | tee -a "$3"
echo "$machine,$limits,fhourstones_0,$base_res_0,False,$res_0" | tee -a "$3"
