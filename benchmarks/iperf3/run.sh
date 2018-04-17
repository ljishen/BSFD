#!/usr/bin/env bash

set -eu

FOLDER_NAME=${FOLDER_NAME:-iperf}
VERSION=${VERSION:-3.5}

if [ "$#" -lt 1 ] || [[ "$1" == --* ]]; then
    cat <<-ENDOFMESSAGE
Please specify at least the output file and mode (server/client).
Usage: ./run.sh <output file> [-s|-c host] [options]

You can use "./run.sh --help" to show a help synopsis.

Examples:
# Run a test in client mode, connecting to an iPerf server running on host (c),
# with report made every other second of the bandwidth (i),
# repeatedly sent an array of bytes for 20 seconds (t),
# and with a 32m TCP buffer (w).
./run.sh output.prof --client iperf.he.net --interval 1 --time 20 --window 32m

# Show a help synopsis and quit.
./run.sh --help
ENDOFMESSAGE

    if [ -f "${FOLDER_NAME}"-"${VERSION}"/src/iperf3 ]; then
        printf "\\n\\n"
        echo "-------------------------------------------------------"
        echo "                Inherited Help Synopsis"
        echo "-------------------------------------------------------"
        echo
        "${FOLDER_NAME}"-"${VERSION}"/src/iperf3 -h
    fi
    exit
fi

if [ ! -f "${FOLDER_NAME}"-"${VERSION}"/src/iperf3 ]; then
    while true; do
        read -rp "Do you wish to install iperf3 (Version $VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                # Pipelining the output from wget to zip is not easy.
                # See https://serverfault.com/a/589528
                # So, we use .tar.gz file instead
                wget -c https://codeload.github.com/esnet/iperf/tar.gz/"$VERSION" -O - | tar -xz
                cd "${FOLDER_NAME}"-"${VERSION}"
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

# Clean up the old output file
rm -f "$1"

mkdir -p "$(dirname "$1")"
printf "\\nSupplied Opertions: %s\\n\\n" "${@:2}"
"${FOLDER_NAME}"-"${VERSION}"/src/iperf3 --verbose --logfile "$1" "${@:2}"
