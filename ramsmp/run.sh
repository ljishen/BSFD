#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify a benchmark ID and the output file as argument.
Usage: ./run.sh <benchmark ID> <output file>

benchmark (by an ID number):
     1 -- INTmark [writing]          4 -- FLOATmark [writing]
     2 -- INTmark [reading]          5 -- FLOATmark [reading]
     3 -- INTmem                     6 -- FLOATmem
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=ramsmp
if [ ! -f $FOLDER_NAME/ramsmp ]; then
    crdir=$(pwd)
    while true; do
        read -p "Do you wish to install RAMspeed/SMP (UNIX) v3.5.0? [y/n] " yn
        case $yn in
            [Yy]* )
                wget http://www.alasir.com/software/ramspeed/ramsmp-3.5.0.tar.gz
                tar -xf ramsmp-3.5.0.tar.gz
                mv ramsmp-3.5.0 $FOLDER_NAME
                rm ramsmp-3.5.0.tar.gz
                cd $FOLDER_NAME
                ./build.sh
                cd $crdir
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
$FOLDER_NAME/ramsmp -p 1 -b $1 | tee $2
