#!/bin/sh

mkdir -p export
rm -f export/*

mkdir -p export_flip
rm -f export_flip/*

find . -type f \( -iname "*.svg" ! -iname ".*" ! -iname "a*" \) -print0 | parallel -0 'x={.}; inkscape -o "export/${x#./}_raw.png" "{}"' \;
./dundundun.sh ablobfoxdundundun
./dundundun.sh ablobfoxdundundunowo
./hyperize.sh ablobfoxhyperowo
./hyperize.sh ablobfoxhypercofe
./hyperize.sh ablobfoxhyperthinking
./hyperize.sh ablobfoxhypersnugowo
./hyperize.sh ablobfoxhyperwhaaaat
./hyperize.sh ablobfoxree
./animate.sh ablobfoxhyper 3 2:100
./animate.sh ablobfoxloading 36 3:100
cp LICENSE export/

cd export
find . -type f -iname "*_raw.png" -print0 | parallel -0 'x={.}; pngquant -o "${x%_raw}.png" "{}"' \;
rm ./*_raw.png
apngasm -o ablobfoxbongo.png blobfoxbongo.png 100 blobfoxbongostart.png 100
apngasm -o ablobfoxbongohyper.png blobfoxbongo.png 5:100 blobfoxbongostart.png 5:100
apngasm -o ablobfoxbongoterrified.png blobfoxbongoterrified.png 5:100 blobfoxbongoterrifiedstart.png 5:100
cp ./*.png ../export_flip/
cp ./LICENSE ../export_flip/


FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.png} $x' {} \;`
jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<< "${FILELIST%|}" > blobfox.json

zip blobfox.zip *.png
zip blobfox.zip LICENSE
tar -cvzf blobfox.tar.gz *.png LICENSE
CHECKSUM=`sha256sum -z blobfox.zip | awk '{ print $1 }'`

cd ../export_flip

rm blobfoxsign*.png blobfoxconfused.png blobfoxbreadsnoot*.png blobfoxsleep.png
find . -type f \( -iname "*.png" ! -iname "a*" \) -exec sh -c 'x=${0#./}; mv $x rev$x' {} \;
mogrify -flop rev*.png
find . -type f -iname "a*.png" -exec sh -c 'x=${0#./a}; ffmpeg -i a$x -vf hflip -f apng -plays 0 arev$x' {} \;
rm ablob*.png
FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.png} $x' {} \;`
jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<< "${FILELIST%|}" > blobfox_flip.json

zip blobfox_flip.zip *.png
zip blobfox_flip.zip LICENSE
tar -cvzf blobfox_flip.tar.gz *.png LICENSE
CHECKSUM_FLIP=`sha256sum -z blobfox_flip.zip | awk '{ print $1 }'`

cd ../export

mv ../export_flip/blobfox_flip.zip ./
mv ../export_flip/blobfox_flip.tar.gz ./
mv ../export_flip/blobfox_flip.json ./

rm -f *.png
rm -f ../export_flip/*

printf '{
    "blobfox": {
        "description": "Like Blobcat, but with foxes",
        "files":       "blobfox.json",
        "homepage":    "https://www.feuerfuchs.dev/projects/blobfox-emojis/",
        "src":         "https://www.feuerfuchs.dev/projects/blobfox-emojis/blobfox.zip",
        "src_sha256":  "%s",
        "license":     "Apache 2.0"
    },
    "blobfox_flip": {
        "description": "Like Blobcat, but with foxes (flipped version)",
        "files":       "blobfox_flip.json",
        "homepage":    "https://www.feuerfuchs.dev/projects/blobfox-emojis/",
        "src":         "https://www.feuerfuchs.dev/projects/blobfox-emojis/blobfox_flip.zip",
        "src_sha256":  "%s",
        "license":     "Apache 2.0"
    }
}' $CHECKSUM $CHECKSUM_FLIP > manifest.json
