#!/bin/bash -e

if [ "$#" -ne 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the output file as argument.
Usage: ./run.sh <output file>
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=interbench
if [ ! -f $FOLDER_NAME/interbench ]; then
    while true; do
        read -p "Do you wish to install Interbench? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://github.com/Mustaavalkosta/interbench/archive/master.zip
                unzip master.zip
                rm master.zip
                mv interbench-master $FOLDER_NAME
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

echo -e "This execution performs real time scheduling benchmarks and uses cpu load of 1 with burn load.\n"

mkdir -p $(dirname $1)
$FOLDER_NAME/interbench -L 1 -c -r | tee $1

echo "Clean working directory..."
rm interbench.read
echo "done."
