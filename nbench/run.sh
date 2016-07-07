#!/bin/bash -e

if [ "$#" -ne 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the output file as argument.
Usage: ./run.sh <output file>
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=nbench
if [ ! -f $FOLDER_NAME/nbench ]; then
    while true; do
        read -p "Do you wish to install Linux/Unix nbench (Version 2.2.3)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://github.com/ljishen/srl/raw/master/kivier/benchmarks/nbench/docker/$FOLDER_NAME-byte-2.2.3.tar.gz
                tar -xf $FOLDER_NAME-byte-2.2.3.tar.gz
                mv $FOLDER_NAME-byte-2.2.3 $FOLDER_NAME
                rm $FOLDER_NAME-byte-2.2.3.tar.gz
                make -C $FOLDER_NAME
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

mkdir -p $(dirname $1)

crdir=$(pwd)
cd $FOLDER_NAME && ./nbench | tee "../$1"
cd $crdir
