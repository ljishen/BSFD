#!/bin/bash -e

if [ "$#" -lt 2 ] || ([ "$1" != "pmbw" ] && [ "$1" != "stats2gnuplot" ]); then
    cat <<-ENDOFMESSAGE
Please specify the program name and the output file (-n) as arguments.
Usage: ./run.sh <pmbw|stats2gnuplot> <stats file> [options]
Options:
  -f <match>     Run only benchmarks containing this substring, can be used multile times. Try "list".
  -M <size>      Limit the maximum amount of memory allocated at startup [byte].
  -o <file>      Write the results to <file> instead of stats.txt.
  -p <nthrs>     Run benchmarks with at least this thread count.
  -P <nthrs>     Run benchmarks with at most this thread count (overrides detected processor count).
  -Q             Run benchmarks with quadratically increasing thread count.
  -s <size>      Limit the _minimum_ test array size [byte]. Set to 0 for no limit.
  -S <size>      Limit the _maximum_ test array size [byte]. Set to 0 for no limit.

Examples:
./run.sh pmbw stats.prof -S 0
./run stats2gnuplot stats.prof
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-pmbw}
VERSION=${VERSION:-4a3b377}
if [ ! -f $FOLDER_NAME/pmbw ]; then
    while true; do
        read -p "Do you wish to install pmbw (Version $VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://raw.githubusercontent.com/ljishen/BSFD/master/benchmarks/pmbw/${VERSION}.zip
                unzip ${VERSION}.zip
                rm ${VERSION}.zip
                mv pmbw-master $FOLDER_NAME
                cd $FOLDER_NAME
                chmod +x configure && ./configure && make
                cd ..
                echo "Successfully installed ${FOLDER_NAME}."
                break
                ;;
            [Nn]* )
                exit
                ;;
            *     )
                echo "Please answer yes or no."
                ;;
        esac
    done
fi

if [ "$1" == "pmbw" ]; then
    mkdir -p "$(dirname $2)"
    $FOLDER_NAME/$1 "${@:3}" | tee "$2"
    rm stats.txt
else
    $FOLDER_NAME/"$1" "$2" | gnuplot

    # copy the plots-<host>.pdf to the same dir as the stats file
    script_path=`dirname $(readlink -f $0)`
    stats_file_path=`dirname $(readlink -f $2)`
    if [ "${script_path}" != "${stats_file_path}" ]; then
        host=`grep -oP -m1 "host=\K[^\s]+" "$2"`
        cp plots-${host}.pdf "${stats_file_path}"
        rm plots-${host}.pdf
    fi
fi
