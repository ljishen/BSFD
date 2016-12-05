#!/bin/bash -e

if [ "$#" -lt 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify arguments.
Usage: ./run.sh [OPTION [ARG]]

Examples:
./run.sh --yaml output.yml --timeout 10 --cpu-method ackermann --cpu 1
./run.sh --yaml output.yml --timeout 20 --class cpu-cache --sequential 1

./run.sh --cpu-method which
./run.sh --class which

./run.sh --help
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-stress-ng}
VERSION=${VERSION:-V0.07.00}
if [ ! -f $FOLDER_NAME/stress-ng ]; then
    while true; do
        read -p "Do you wish to install Stress-ng (Version $VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://github.com/ColinIanKing/stress-ng/archive/$VERSION.tar.gz
                mkdir $FOLDER_NAME
                tar -xf $VERSION.tar.gz -C $FOLDER_NAME --strip-components=1
                rm $VERSION.tar.gz
                CC=gcc make -C $FOLDER_NAME
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

$FOLDER_NAME/stress-ng --metrics-brief --times --verbose "$@"
