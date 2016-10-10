#!/bin/bash -e

if [ "$#" -ne 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the output file as argument.
Usage: ./run.sh <output file>
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-fhourstones}
if [ ! -f $FOLDER_NAME/SearchGame ]; then
    while true; do
        read -p "Do you wish to install The Fhourstones Benchmark (version 3.1)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://tromp.github.io/c4/Fhourstones.tar.gz
                mkdir $FOLDER_NAME
                tar -xf Fhourstones.tar.gz -C $FOLDER_NAME
                rm Fhourstones.tar.gz
                gcc -O $FOLDER_NAME/SearchGame.c -o $FOLDER_NAME/SearchGame
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

mkdir -p $(dirname $1)
$FOLDER_NAME/SearchGame < $FOLDER_NAME/inputs | tee $1
