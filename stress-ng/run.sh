#!/bin/bash -e

if [ "$#" -ne 2 ]; then
    cat <<-ENDOFMESSAGE
Please specify the output file and the hostname as arguments.
Usage: ./run.sh <output file> [user@]<hostname>
ENDOFMESSAGE
    exit
fi

FOLDER_NAME=stress-ng
VERSION=V0.06.12
if [ ! -f $FOLDER_NAME/stress-ng ]; then
    while true; do
        read -p "Do you wish to install Stress-ng ($VERSION)? [y/n] " yn
        case $yn in
            [Yy]* )
                wget https://github.com/ColinIanKing/stress-ng/archive/$VERSION.tar.gz
                mkdir $FOLDER_NAME
                tar -xf $VERSION.tar.gz -C $FOLDER_NAME --strip-components=1
                rm $VERSION.tar.gz
                CC=gcc make -C $FOLDER_NAME
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

if [ -z "$BENCHMARKS" ] ; then
  BENCHMARKS="cpu-methods cpu-class cpu-cache memory matrix-methods string-methods"
fi

if [ -z $NUM_WORKERS ] ; then
  NUM_WORKERS=1
fi

if [ -z $TIMEOUT ] ; then
  TIMEOUT=10
fi

STRESS_NG_OUTPUT_FILE=stress-ng_out.yml
COMMON="$NUM_WORKERS -t $TIMEOUT --metrics-brief --times -Y $STRESS_NG_OUTPUT_FILE"

function include_comma {
  if [ "$need_comma" = true ] ; then
    echo "," | tee -a "$1"
  else
    need_comma=true
  fi
}

function get_category {
  if [ $1 == "stream" ] ; then
    category="memory"
  elif [ $1 == *"matrix"* ] ; then
    category="memory"
  elif [ $1 == *"memory"* ] ; then
    category="memory"
  else
    category="cpu"
  fi
}

need_comma=false
category="foo"

remote_user_at_host="$2"

scp yaml2json.py $remote_user_at_host:/tmp/yaml2json.py &> /dev/null

echo "[" | tee "$1"

for bench in $BENCHMARKS ; do
  if [[ $bench == "cpu-methods" ]] ; then
    include_comma "$1"
    for method in ackermann bitops callfunc cdouble cfloat clongdouble correlate crc16 decimal32 decimal64 decimal128 dither djb2a double euler explog fft fibonacci float fnv1a gamma gcd gray hamming hanoi hyperbolic idct int128 int64 int32 int16 int8 int128float int128double int128longdouble int128decimal32 int128decimal64 int128decimal128 int64float int64double int64longdouble int32float int32double int32longdouble jenkin jmp ln2 longdouble loop matrixprod nsqrt omega parity phi pi pjw prime psi queens rand rand48 rgb sdbm sieve sqrt trig union zeta ; do
       $FOLDER_NAME/stress-ng --cpu-method $method --cpu $COMMON &> /dev/null
       scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
       ssh $remote_user_at_host "/tmp/yaml2json.py cpu $method" | tee -a "$1"
       if [ "$method" != "zeta" ] ; then
         # print comma for all but the last (zeta)
         echo "," | tee -a "$1"
       fi
    done
  elif [[ $bench == "matrix-methods" ]] ; then
    include_comma "$1"
    for method in add div frobenius mult prod sub hadamard trans ; do
       $FOLDER_NAME/stress-ng --matrix-method $method --matrix $COMMON &> /dev/null
       scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
       ssh $remote_user_at_host "/tmp/yaml2json.py matrix $method" | tee -a "$1"
       if [ "$method" != "trans" ] ; then
         echo "," | tee -a "$1"
       fi
    done
  elif [[ $bench == "string-methods" ]] ; then
    include_comma "$1"
    for method in index rindex strcasecmp strcat strchr strcoll strcmp strcpy strlen strncasecmp strncat strncmp strrchr strxfrm ; do
       $FOLDER_NAME/stress-ng --str-method $method --str $COMMON &> /dev/null
       scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
       ssh $remote_user_at_host "/tmp/yaml2json.py string $method" | tee -a "$1"
       if [ "$method" != "strxfrm" ] ; then
         echo "," | tee -a "$1"
       fi
    done
  elif [[ $bench == "cpu-class" ]] ; then
    include_comma "$1"
    $FOLDER_NAME/stress-ng --class cpu --exclude matrix,context --sequential $COMMON &> /dev/null
    scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
    ssh $remote_user_at_host "/tmp/yaml2json.py cpu" | tee -a "$1"
  elif [[ $bench == "memory" ]] ; then
    include_comma "$1"
    $FOLDER_NAME/stress-ng --class memory --exclude bsearch,hsearch,lsearch,qsort,wcs,tsearch,stream,numa --sequential $COMMON &> /dev/null
    scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
    ssh $remote_user_at_host "/tmp/yaml2json.py memory" | tee -a "$1"
  elif [[ $bench == "cpu-cache" ]] ; then
    include_comma "$1"
    $FOLDER_NAME/stress-ng --class cpu-cache --exclude bsearch,hsearch,lockbus,lsearch,vecmath,matrix,qsort,malloc,str,stream,memcpy,wcs,tsearch --sequential $COMMON &> /dev/null
    scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
    ssh $remote_user_at_host "/tmp/yaml2json.py cpu-cache" | tee -a "$1"
  else
    # if we didn't get "special" id, then we assume it's a regular stressor
    include_comma "$1"
    $FOLDER_NAME/stress-ng "--$bench" $COMMON &> /dev/null
    get_category $bench
    scp $STRESS_NG_OUTPUT_FILE $remote_user_at_host:/tmp/$STRESS_NG_OUTPUT_FILE &> /dev/null
    ssh $remote_user_at_host "/tmp/yaml2json.py $category" | tee -a "$1"
  fi
done

echo "]" | tee -a "$1"
