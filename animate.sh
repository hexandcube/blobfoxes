#!/bin/sh

SOURCEBASE=$1
MAX=$2
DELAY=$3
SOURCESVG=`printf "%s.svg" $SOURCEBASE`
TARGETSVG=`printf "export/%s.png" $SOURCEBASE`


mkdir -p export_tmp
rm -f export_tmp/*


counter=1
while [ $counter -le $MAX ]
do
    source=`printf "%s%s.svg" $SOURCEBASE $counter`
    file=`printf "export_tmp/%s_raw.png" $counter`
    filecomp=`printf "export_tmp/%s.png" $counter`
    inkscape -o $file $source
    pngquant -o $filecomp $file
    ((counter++))
done


declare -a args

counter=1
while [ $counter -le $MAX ]
do
    file=`printf "export_tmp/%s.png" $counter`
    args+=($file $DELAY)
    ((counter++))
done

apngasm -o $TARGETSVG ${args[@]}
#rm -f export_tmp/*
