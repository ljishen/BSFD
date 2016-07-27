#!/bin/bash -e

if [ "$#" -ne 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the file base name for benchmark and output.
Usage: ./run.sh <file base name>
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=pybench
if [ ! -f $FOLDER_NAME/pybench.py ]; then
    while true; do
        read -p "Do you wish to install PYBENCH? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://github.com/ljishen/srl/raw/master/kivier/benchmark-suite/pybench/docker/pybench-r89074.tar.gz 
                tar -xf pybench-r89074.tar.gz
                rm pybench-r89074.tar.gz
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
$FOLDER_NAME/pybench.py -f $1.pybench | tee $1.prof
