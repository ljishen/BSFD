#!/usr/bin/env bash

set -eu

if [ "$#" -lt 2 ] || ([ "$1" != "pmbw" ] && [ "$1" != "stats2gnuplot" ]); then
    cat <<-ENDOFMESSAGE
Please specify the program name and the stats file as arguments.
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
./run.sh stats2gnuplot stats.prof
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-pmbw}
VERSION=${VERSION:-fc71268}
if [ ! -f "$FOLDER_NAME"/pmbw ]; then
    while true; do
        read -rp "Do you wish to install pmbw (Version $VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://codeload.github.com/bingmann/pmbw/zip/"${VERSION}" && \
                    unzip -qo "${VERSION}" && \
                    rm "${VERSION}" && \
                    mv pmbw-"${VERSION}" "$FOLDER_NAME"
                cd "$FOLDER_NAME"
                ./configure && make -j"$(nproc)"
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

OUTPUT="$2"

if [ "$1" == "pmbw" ]; then
    mkdir -p "$(dirname "$OUTPUT")"

    ORIG_OUTPUT="stats.txt"
    function clean_up {
        if [ -f "$ORIG_OUTPUT" ]; then
            mv "$ORIG_OUTPUT" "$OUTPUT"
        fi
        exit $?
    }

    # Trap the exit signal
    # See https://raymii.org/s/snippets/Bash_Bits_Trap_Control_C_SIGTERM.html
    trap clean_up SIGINT
    trap clean_up SIGTERM

    "$FOLDER_NAME"/"$1" "${@:3}" && mv "$ORIG_OUTPUT" "$OUTPUT"
else
    "$FOLDER_NAME"/"$1" "$OUTPUT" | gnuplot

    # Copy the plots-<host>.pdf to the same dir as the stats file
    script_path=$(dirname "$(readlink -f "$0")")
    stats_file_path=$(dirname "$(readlink -f "$OUTPUT")")
    if [ "${script_path}" != "${stats_file_path}" ]; then
        host=$(grep -oP -m1 "host=\\K[^\\s]+" "$OUTPUT")
        mv plots-"${host}".pdf "${stats_file_path}"
    fi
fi
