#!/bin/bash -e

if [ "$#" -ne 3 ]; then
    cat <<-ENDOFMESSAGE
Please specify the base result file and the result file, as well as the output file as arguments.
Usage: ./parse.sh <base result file> <result file> <output file>
ENDOFMESSAGE
    exit
fi

mkdir -p $(dirname $3)

test_list=('None' 'Video' 'X' 'Burn' 'Write' 'Read' 'Compile')

for test in "${test_list[@]}"; do
    pattern="^$test\s+\K[\d.]+"
    
    base_reses=(`grep -oP "$pattern" "$1"`)
    reses=(`grep -oP "$pattern" "$2"`)

    test_name=`echo "$test" | sed "s/[A-Z]/\l&/g"`
    echo "interbench_audio_$test_name,${base_reses[0]},True,${reses[0]}" | tee -a "$3"

    if [ "$test" != "Video" ]; then
        echo "interbench_video_$test_name,${base_reses[1]},True,${reses[1]}" | tee -a "$3"
    fi
done
