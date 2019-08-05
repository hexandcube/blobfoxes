#!/bin/sh

mkdir -p export
rm -f export/*

find . -type f -iname '*.svg' -print0 | parallel -0 'x={.}; inkscape -z -e "export/${x#./}.png" "{}"' {} \;
cp LICENSE export/

cd export

FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.png} $x' {} \;`
jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<< "${FILELIST%|}" > blobfox.json

rm -f blobfox.zip
zip blobfox.zip *.png
zip blobfox.zip LICENSE
CHECKSUM=`sha256sum -z blobfox.zip | awk '{ print $1 }'`

printf '{
    "blobfox": {
        "description": "Like Blobcat, but with foxes",
        "files":       "blobfox.json",
        "homepage":    "https://www.feuerfuchs.dev/projects/blobfox-emojis/",
        "src":         "https://www.feuerfuchs.dev/projects/blobfox-emojis/blobfox.zip",
        "src_sha256":  "%s",
        "license":     "Apache 2.0"
    }
}' $CHECKSUM > manifest.json
