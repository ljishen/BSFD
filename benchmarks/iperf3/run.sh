#!/usr/bin/env bash

set -eu

FOLDER_NAME=${FOLDER_NAME:-iperf}
VERSION=${VERSION:-3.5}

if [ "$#" -eq 0 ] || [[ "$1" == --[^i]* ]]; then
    cat <<-ENDOFMESSAGE
Please specify at least the output file and mode (server/client).
Usage: ./run.sh FILE [-s|-c host] [options]

You can use "./run.sh --help" to show a help synopsis.

Examples:
# Run a test in client mode, connecting to an iPerf server running on host (c),
# with report made every other second of the bandwidth (i),
# repeatedly sent an array of bytes for 20 seconds (t),
# using a 32m TCP buffer (w).
./run.sh output.prof --client iperf.he.net --interval 1 --time 20 --window 32m

# Show a help synopsis and quit
./run.sh --help

# To just install the iPerf 3 in the current directory, use
./run.sh --install
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
        read -rp "Do you want to install iPerf 3 (Version $VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                # Pipelining the output from wget to zip is not easy.
                # See https://serverfault.com/a/589528
                # So, we use .tar.gz file instead
                wget -c https://codeload.github.com/esnet/iperf/tar.gz/"$VERSION" -O - | tar -xz
                cd "${FOLDER_NAME}"-"${VERSION}"
                ./configure && make -j"$(nproc)"
                cd ..
                echo "Successfully installed iPerf 3."
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
elif [[ "$1" == --i* ]]; then
    echo "iPerf 3 is already installed."
fi

if [[ "$1" == --i* ]]; then
    exit
fi

# Clean up the old output file
rm -f "$1"

mkdir -p "$(dirname "$1")"
printf "\\nSupplied Options: "
echo "${@:2}"
echo
"${FOLDER_NAME}"-"${VERSION}"/src/iperf3 "${@:2}" 2>&1 | tee "$1"
