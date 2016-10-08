#!/bin/sh -e

if [ "$#" -lt 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the execution type.
Usage: ./run.sh <bench|compare> <ARGS>
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

if [ "$1" == "bench" ] || [ "$1" == "compare" ]; then
    # Variable sharing using "."
    # See http://stackoverflow.com/questions/9772036/pass-all-variables-from-one-shellscript-to-another
    . ./"$@"
else
    echo "Error: unknown execution type \"$1\". (Only \"bench\" or \"compare\" are allowed)"
fi
