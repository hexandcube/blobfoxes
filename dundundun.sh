#!/bin/sh

source ./shakeoffsets.sh

declare -a shakeOffsets
getShakeOffsets shakeOffsets

SOURCEBASE=$1
SOURCESVG=`printf "%s.svg" $SOURCEBASE`
TARGETSVG=`printf "export/%s.png" $SOURCEBASE`

mkdir -p export_tmp
rm -f export_tmp/*


inkscape -z -e "export_tmp/1.png" `printf "%s1.png" $SOURCEBASE`
inkscape -z -e "export_tmp/2.png" `printf "%s2.png" $SOURCEBASE`
inkscape -z -e "export_tmp/3.png" `printf "%s3.png" $SOURCEBASE`
inkscape -z -e "export_tmp/4.png" `printf "%s4.png" $SOURCEBASE`

counter=5
while [ $counter -le 79 ]
do
    offset=${shakeOffsets[counter-5]}
    file=`printf "export_tmp/%s.png" $counter`
    source=`printf "%s4.png" $SOURCEBASE`
    inkscape -z -e $file -a $offset $source
    ((counter++))
done


declare -a args
args+=(export_tmp/1.png 50:50)
args+=(export_tmp/2.png 12:50)
args+=(export_tmp/3.png 12:50)

counter=4
while [ $counter -le 79 ]
do
    file=`printf "export_tmp/%s.png" $counter`
    args+=($file 1:50)
    ((counter++))
done

apngasm -o $TARGETSVG ${args[@]}
rm -f export_tmp/*
