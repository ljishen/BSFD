#!/bin/bash -e

if [ "$#" -lt 1 ]; then
    cat <<-ENDOFMESSAGE
Please specify the output file as argument.
Usage: ./run.sh <output file>

There are five parameters:
(1) the transposition table size
(2) the number of search threads that should be used
(3) the limit value spent for each position (optional, default is depth 13)
(4) an optional file name where to look for positions in FEN format
(5) the type of the limit value: depth (default), time in millisecs or number of nodes.
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=stockfish-7
if [ ! -f $FOLDER_NAME/src/stockfish ]; then
    while true; do
        read -p "Do you wish to install Stockfish 7? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://stockfish.s3.amazonaws.com/$FOLDER_NAME-src.zip
                unzip -q $FOLDER_NAME-src.zip
                mv $FOLDER_NAME-src $FOLDER_NAME
                rm $FOLDER_NAME-src.zip

                cat <<-ENDOFMESSAGE


Supported archs:

0. x86-64                  > x86 64-bit
1. x86-64-modern           > x86 64-bit with popcnt support
2. x86-64-bmi2             > x86 64-bit with pext support
3. x86-32                  > x86 32-bit with SSE support
4. x86-32-old              > x86 32-bit fall back for old hardware
5. ppc-64                  > PPC 64-bit
6. ppc-32                  > PPC 32-bit
7. armv7                   > ARMv7 32-bit
8. general-64              > unspecified 64-bit
9. general-32              > unspecified 32-bit
ENDOFMESSAGE
                while true; do
                    read -p "Choose the number of ARCH you want to build with [0-9]: " num
                    case $num in
                        0 )
                            arch=x86-64
                            break
                            ;;
                        1 )
                            arch=x86-64-modern
                            break
                            ;;
                        2 )
                            arch=x86-64-bmi2
                            break
                            ;;
                        3 )
                            arch=x86-32
                            break
                            ;;
                        4 )
                            arch=x86-32-old
                            break
                            ;;
                        5 )
                            arch=ppc-64
                            break
                            ;;
                        6 )
                            arch=ppc-32
                            break
                            ;;
                        7 )
                            arch=armv7
                            break
                            ;;
                        8 )
                            arch=general-64
                            break
                            ;;
                        9 )
                            arch=general-32
                            break
                            ;;
                        * )
                            echo "Please enter a number [0-9]."
                            ;;
                    esac
                done
                
                comp=gcc
                cat <<-ENDOFMESSAGE


Supported compilers:

0. gcc                     > Gnu compiler (default)
1. mingw                   > Gnu compiler with MinGW under Windows
2. clang                   > LLVM Clang compiler
3. icc                     > Intel compiler
ENDOFMESSAGE
                read -p "Choose the number of compiler you want to build with [0-3] (default 0): " num
                case $num in
                    0 )
                        comp=gcc
                        ;;
                    1 )
                        comp=mingw
                        ;;
                    2 )
                        comp=clang
                        ;;
                    3 )
                        comp=icc
                        ;;
                esac

                make -C $FOLDER_NAME/src build ARCH=$arch COMP=$comp
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

# The default execution arguments:
# - 16      as the transposition table size
# - 1       as the number of search threads that should be used
# - 13      as the limit value spent for each position
# - default as the optional file name where to look for positions in FEN format
# - depth   as the type of the limit value: depth (default), time in millisecs or number of nodes.
# See https://github.com/mcostalba/Stockfish/blob/master/src/benchmark.cpp
$FOLDER_NAME/src/stockfish bench "${@:2}" 2>&1 | tee $1
