#!/bin/sh

mkdir -p export
rm -f export/*

mkdir -p export_flip
rm -f export_flip/*

find . -type f -iname '*.svg' -print0 | parallel -0 'x={.}; inkscape -z -e "export/${x#./}.png" "{}"' {} \;
cp LICENSE export/
cp export/* export_flip/

cd export

FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.png} $x' {} \;`
jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<< "${FILELIST%|}" > blobfox.json

zip blobfox.zip *.png
zip blobfox.zip LICENSE
CHECKSUM=`sha256sum -z blobfox.zip | awk '{ print $1 }'`

cd ../export_flip

rm blobfoxsign*.png blobfoxconfused.png blobfoxbottompeek2.png blobfoxbreadsnoot*.png blobfoxrealisticbreadsnoot*.png
find . -type f -iname '*.png' -exec sh -c 'x=${0#./blobfox}; mv blobfox$x revblobfox$x' {} \;
mogrify -flop *.png
FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.png} $x' {} \;`
jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<< "${FILELIST%|}" > blobfox_flip.json

zip blobfox_flip.zip *.png
zip blobfox_flip.zip LICENSE
CHECKSUM_FLIP=`sha256sum -z blobfox_flip.zip | awk '{ print $1 }'`

cd ../export

mv ../export_flip/blobfox_flip.zip ./
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
