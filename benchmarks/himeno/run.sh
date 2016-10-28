#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify the Grid-size and the output file as arguments.
Usage: ./run.sh <XS/S/M/L/XL> <output file>
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-himeno}
if [ ! -f $FOLDER_NAME/himenoBMTxpa ]; then
    while true; do
        read -p "Do you wish to install Himeno benchmark? [y/n] " yn
        case $yn in
            [Yy]* )
                mkdir $FOLDER_NAME
                wget -O $FOLDER_NAME/himenoBMTxpa.c https://raw.githubusercontent.com/ljishen/BSFD/master/benchmarks/himeno/himenoBMTxpa.c
                gcc $FOLDER_NAME/himenoBMTxpa.c -O3 -o $FOLDER_NAME/himenoBMTxpa
                rm $FOLDER_NAME/himenoBMTxpa.c
                echo "Successfully install ${FOLDER_NAME}."
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

mkdir -p $(dirname $2)
$FOLDER_NAME/himenoBMTxpa $1 | tee $2
