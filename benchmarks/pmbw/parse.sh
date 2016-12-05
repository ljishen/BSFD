#!/bin/bash -e

# The script arguments requirement is just for matching the convention of Benchmark Collections in this repository.

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

# Since pmbw provides the stats2gnuplot program for visualizing the statistical output, we use it directly.

run_script=$(dirname $(readlink -f $0))/run.sh
yes | ${run_script} stats2gnuplot "$1"
yes | ${run_script} stats2gnuplot "$2"

base_host=`grep -oP -m1 "host=\K[^\s]+" "$1"`
host=`grep -oP -m1 "host=\K[^\s]+" "$2"`

out_file_dir="$(dirname "$3")"
base_res_dir="$(dirname $(readlink -f $1))"
res_dir="$(dirname $(readlink -f $2))"

if [ "${base_res_dir}" != "${out_file_dir}" ]; then
    cp "${base_res_dir}"/plots-${base_host}.pdf "${out_file_dir}"/pmbw-plots-${base_host}.pdf
    rm "${base_res_dir}"/plots-${base_host}.pdf
fi

if [ "${res_dir}" != "${out_file_dir}" ]; then
    cp "${res_dir}"/plots-${host}.pdf "${out_file_dir}"/pmbw-plots-${host}.pdf
    rm "${res_dir}"/plots-${host}.pdf
fi

# clean up
rm -rf pmbw
