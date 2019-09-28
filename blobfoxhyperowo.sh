#!/bin/sh

source ./shakeoffsets.sh

declare -a shakeOffsets
getShakeOffsets shakeOffsets


mkdir -p export_tmp
rm -f export_tmp/*


counter=1
while [ $counter -le 75 ]
do
    offset=${shakeOffsets[counter-1]}
    file=`printf "export_tmp/%s.png" $counter`
    inkscape -z -e $file -a $offset "blobfoxhyperowo.svg"
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

apngasm -o export/ablobfoxhyperowo.png ${args[@]}
rm -f export_tmp/*
