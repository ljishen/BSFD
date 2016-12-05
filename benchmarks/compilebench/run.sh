#!/bin/bash -e

if [ "$#" -lt 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify a working directory and the output file as argument.
Usage: ./run.sh <output file> <working directory> [OPTION]

Options:
  -h, --help            show this help message and exit
  -b BUFFER_SIZE, --buffer-size=BUFFER_SIZE
                        buffer size (bytes)
  -i INITIAL_DIRS, --initial-dirs=INITIAL_DIRS
                        number of dirs initially created
  -r RUNS, --runs=RUNS  number of rand op runs
  -D DIRECTORY, --directory=DIRECTORY
                        working directory
  -s SOURCES, --sources=SOURCES
                        data set source file directory
  -t TRACE, --trace=TRACE
                        blktrace output file
  -d DEVICE, --device=DEVICE
                        blktrace device
  -m, --makej           simulate a make -j on the initial dirs and exit
  -n, --no-sync         don't sync and drop caches between each iteration

Examples:
./run.sh output.prof /tmp/compilebench --help
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=${FOLDER_NAME:-compilebench}
VERSION=${VERSION:-0.6}

if [ ! -f ${FOLDER_NAME}/compilebench ]; then
    while true; do
        read -p "Do you wish to install Compilebench v${VERSION}? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://oss.oracle.com/~mason/compilebench/${FOLDER_NAME}-${VERSION}.tar.bz2
                mkdir $FOLDER_NAME
                tar -xf ${FOLDER_NAME}-${VERSION}.tar.bz2 -C $FOLDER_NAME --strip-components=1
                rm ${FOLDER_NAME}-${VERSION}.tar.bz2
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

mkdir -p $(dirname $1)
mkdir -p "$2"

out_file="$1"
if [[ "$1" != /* ]]; then
    out_file="../$1"
fi

work_dir="$2"
if [[ "$2" != /* ]]; then
    work_dir="../$2"
fi

# "${@:3}" Only keep the arguments from the thrid.
cd $FOLDER_NAME && ./compilebench -D "$work_dir" "${@:3}" 2>&1 | tee "$out_file"

cd ..

echo -e "\nClean working directory..."
rm -rf "$2"
echo "done."
