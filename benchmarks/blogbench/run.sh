#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify an writable working directory and output file as argument.
Usage: ./run.sh <working directory> <output file> [OPTION]
ENDOFMESSAGE
    exit
fi

if ! command -v blogbench >/dev/null 2>&1; then
    while true; do
        read -p "Do you wish to install Blogbench 1.1? [y/n] " yn
        case $yn in
            [Yy]* )
                FOLDER_NAME=${FOLDER_NAME:-blogbench-1.1}
                wget https://download.pureftpd.org/pub/blogbench/$FOLDER_NAME.tar.gz
                tar -xf $FOLDER_NAME.tar.gz
                cd $FOLDER_NAME
                ./configure
                make install-strip
                cd ..
                rm -rf $FOLDER_NAME $FOLDER_NAME.tar.gz
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

mkdir -p $1
mkdir -p $(dirname $2)
blogbench -d $1 "${@:3}" | tee $2

echo "Clean working directory..."
rm -rf $1
echo "done."
