#!/bin/bash -e

if [ "$#" -lt 1 ]; then
    cat <<-ENDOFMESSAGE
Please at least specify the output file and benchmark ID as argument.
Usage: ./run.sh <output file> <ARGS>

Example: ./run.sh output.prof -p 1 -b 1

benchmark (by an ID number):
     1 -- INTmark [writing]          4 -- FLOATmark [writing]
     2 -- INTmark [reading]          5 -- FLOATmark [reading]
     3 -- INTmem                     6 -- FLOATmem
     7 -- MMXmark [writing]         10 -- SSEmark [writing]
     8 -- MMXmark [reading]         11 -- SSEmark [reading]
     9 -- MMXmem                    12 -- SSEmem
    13 -- MMXmark (nt) [writing]    16 -- SSEmark (nt) [writing]
    14 -- MMXmark (nt) [reading]    17 -- SSEmark (nt) [reading]
    15 -- MMXmem (nt)               18 -- SSEmem (nt)
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-ramsmp}
if [ ! -f $FOLDER_NAME/ramsmp ]; then
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

mkdir -p $(dirname "$1")
$FOLDER_NAME/ramsmp ${@:2} | tee "$1"
