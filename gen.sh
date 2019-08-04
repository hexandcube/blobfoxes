#!/bin/sh

FILELIST=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s:%s|" ${x%.svg.png} $x' {} \;`

jq -Rn 'input | split("|") | map(split(":") | { key: .[0], value: .[1] }) | from_entries' <<<"${FILELIST%|}">blobfox.json

zip blobfox.zip *.png
