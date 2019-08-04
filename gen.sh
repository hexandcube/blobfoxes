#!/bin/sh

IDS=`find . -type f -iname '*.png' -exec sh -c 'x=${0#./}; printf "%s|" ${x%.svg.png}' {} \;`
FILES=`find . -type f -iname '*.png' -exec sh -c 'printf "%s|" ${0#./}' {} \;`

FILELIST="${IDS%|}
${FILES%|}"

jq -Rn '
( input  | split("|") ) as $keys |
( inputs | split("|") ) as $vals |
[[$keys, $vals] | transpose[] | {key:.[0],value:.[1]}] | from_entries
' <<<"$FILELIST">blobfox.json

zip blobfox.zip *.png
