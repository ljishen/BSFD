#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
The result should be named in this format: <limits>_<machine>_<prot>_<opts>.prof (e.g. without_kv3_tcp_w32.prof)

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

prot=`echo "$bn" | cut -d _ -f 3`
prot=${prot,,}  # to lowercase
base_prot=`echo $(basename "$1" ".prof") | cut -d _ -f 3`
base_prot=${base_prot,,}

PROTS="tcp udp"
if [ "${prot}" != "${base_prot}" ] || ! [[ "$PROTS" =~ "${prot}" ]]; then
    echo "Please check the if result files are from test using the same protocol (TCP/UDP). (Current protocol: ${base_prot} and ${prot})"
    exit
fi

opts=`echo "$bn" | cut -d _ -f 4-`
machine=`echo "$bn" | cut -d _ -f 2`
limits=`echo "$bn" | cut -d _ -f 1`

pb="grep -oP [\d\.]+(?=\sMbits/sec)"

if [ "${prot}" == "tcp" ]; then
    roles=('sender' 'receiver')
    for role in "${roles[@]}"; do
        base_res=$(grep "${role}" $1 | ${pb})
        res=$(grep "${role}" $2 | ${pb})

        echo "$machine,$limits,iperf3_${prot}_${opts}_${role},$base_res,False,$res" | tee -a "$3"
    done
else
    base_res=$(grep -A1 "Lost" $1 | ${pb})
    res=$(grep -A1 "Lost" $2 | ${pb})

    echo "$machine,$limits,iperf3_${prot}_${opts},$base_res,False,$res" | tee -a "$3"
fi
