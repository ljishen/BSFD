#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify at least the output file and mode (server/client).
Usage: ./run.sh <output file> [-s|-c host] [options]

You can use "./run.sh <output file> --help" show a help synopsis. 

Examples:
# Run a test in client mode, connecting to an iPerf server running on host (c),
# with report made every other second of the bandwidth (i),
# repeatedly sent an array of bytes for 20 seconds (t),
# and with a 32m TCP buffer (w).
./run.sh output.prof --client iperf.he.net --interval 1 --time 20 --window 32m

# Show a help synopsis and quit.
./run.sh output.prof --help
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-iperf}
VERSION=${VERSION:-3.1.3}
if [ ! -f ${FOLDER_NAME}-${VERSION}/src/iperf3 ]; then
    while true; do
        read -p "Do you wish to install iperf3 (Version $VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://github.com/esnet/iperf/archive/${VERSION}.tar.gz
                tar -xf ${VERSION}.tar.gz
                rm ${VERSION}.tar.gz
                cd ${FOLDER_NAME}-${VERSION}
                ./configure; make
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

rm -f "$1"
mkdir -p $(dirname "$1")
${FOLDER_NAME}-${VERSION}/src/iperf3 --verbose --affinity 1 --format m --logfile "$1" "${@:2}"
