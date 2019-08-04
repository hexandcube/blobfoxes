#!/bin/sh

FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.svg.png} $x' {} \;`

jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<< "${FILELIST%|}" > blobfox.json

zip blobfox.zip *.png

CHECKSUM=`sha256sum -z blobfox.zip | awk '{ print $1 }'`

printf '{
    "src":         "https://git.pleroma.social/pleroma/emoji-index/raw/master/packs/blobfox.zip",
    "src_sha256":  "%s",
    "license":     "Apache 2.0",
    "files":       "blobfox.json",
    "description": "Like Blobcat, except with foxes"
}' $CHECKSUM > index.json
