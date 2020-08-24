#!/bin/sh

source ./shakeoffsets.sh

declare -a shakeOffsets
getShakeOffsets shakeOffsets

SOURCEBASE=$1
SOURCESVG=`printf "%s.svg" $SOURCEBASE`
TARGETSVG=`printf "export/%s.png" $SOURCEBASE`


mkdir -p export_tmp
rm -f export_tmp/*


counter=1
NUMPROCS=8
NUMJOBS="\j"
while [ $counter -le 75 ]
do
    while (( ${NUMJOBS@P} >= NUMPROCS )); do
        wait -n
    done
    offset=${shakeOffsets[counter-1]}
    file=`printf "export_tmp/%s_raw.png" $counter`
    inkscape -o $file --export-area=$offset $SOURCESVG &
    ((counter++))
done

wait -n


counter=1
while [ $counter -le 75 ]
do
    file=`printf "export_tmp/%s.png" $counter`
    source=`printf "export_tmp/%s_raw.png" $counter`
    pngquant -o $file $source &
    ((counter++))
done

wait -n


declare -a args

counter=1
while [ $counter -le 75 ]
do
    file=`printf "export_tmp/%s.png" $counter`
    args+=($file 1:50)
    ((counter++))
done

apngasm -o $TARGETSVG ${args[@]}
#rm -f export_tmp/*
