#!/bin/sh

source ./shakeoffsets.sh

declare -a shakeOffsets
getShakeOffsets shakeOffsets

SOURCEBASE=$1
SOURCESVG=`printf "%s.svg" $SOURCEBASE`
TARGETSVG=`printf "export/a%s.png" $SOURCEBASE`


mkdir -p export_tmp
rm -f export_tmp/*


counter=1
while [ $counter -le 75 ]
do
    offset=${shakeOffsets[counter-1]}
    file=`printf "export_tmp/%s.png" $counter`
    inkscape -z -e $file -a $offset $SOURCESVG
    ((counter++))
done


declare -a args

counter=1
while [ $counter -le 75 ]
do
    file=`printf "export_tmp/%s.png" $counter`
    args+=($file 1:50)
    ((counter++))
done

apngasm -o $TARGETSVG ${args[@]}
rm -f export_tmp/*
