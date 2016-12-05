#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify the program and the output file as arguments.
Usage: ./run.sh <pmbw|stats2gnuplot> <output file> [options]
Options:
  -f <match>     Run only benchmarks containing this substring, can be used multile times. Try "list".
  -M <size>      Limit the maximum amount of memory allocated at startup [byte].
  -o <file>      Write the results to <file> instead of stats.txt.
  -p <nthrs>     Run benchmarks with at least this thread count.
  -P <nthrs>     Run benchmarks with at most this thread count (overrides detected processor count).
  -Q             Run benchmarks with quadratically increasing thread count.
  -s <size>      Limit the _minimum_ test array size [byte]. Set to 0 for no limit.
  -S <size>      Limit the _maximum_ test array size [byte]. Set to 0 for no limit.
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
                wget https://github.com/ljishen/BSFD/blob/master/benchmarks/pmbw/${VERSION}.zip
                unzip ${VERSION}.zip
                rm ${VERSION}.zip
                mv pmbw-master $FOLDER_NAME
                cd $FOLDER_NAME
                chmod +x configure
                ./configure && make
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

OUTPUT_DIR="$(dirname "$2")"
mkdir -p ${OUTPUT_FILE}

if [ "$1" == "pmbw" ]; then
    $FOLDER_NAME/$1 "${@:3}" | tee "$2"
    # copy stats.txt to the same directory as output file
    STATS_FILE="stats.txt"
    cp "${STATS_FILE}" /tmp/
    rm "${STATS_FILE}"
    cp /tmp/"${STATS_FILE}" "${OUTPUT_DIR}"
    rm /tmp/"${STATS_FILE}"
elif [ "$1" == "stats2gnuplot" ]; then
    $FOLDER_NAME/$1 stats2gnuplot "${OUTPUT_DIR}"/stats.txt | gnuplot | tee "$2"
else
    echo "Available programs are: \"pmbw\" and \"stats2gnuplot\""
fi
