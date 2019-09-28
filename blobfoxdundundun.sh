#!/bin/sh

source ./shakeoffsets.sh

declare -a shakeOffsets
getShakeOffsets shakeOffsets


mkdir -p export_tmp
rm -f export_tmp/*


inkscape -z -e "export_tmp/1.png" "blobfoxdundundun1.svg"
inkscape -z -e "export_tmp/2.png" "blobfoxdundundun2.svg"
inkscape -z -e "export_tmp/3.png" "blobfoxdundundun3.svg"
inkscape -z -e "export_tmp/4.png" "blobfoxdundundun4.svg"

counter=5
while [ $counter -le 79 ]
do
    offset=${shakeOffsets[counter-5]}
    file=`printf "export_tmp/%s.png" $counter`
    inkscape -z -e $file -a $offset "blobfoxdundundun4.svg"
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

apngasm -o export/ablobfoxdundundun.png ${args[@]}
rm -f export_tmp/*
