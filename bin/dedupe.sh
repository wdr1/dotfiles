#!/bin/sh
[ -e dedupe.mbox ] && echo 'panic: dedupe.mbox exists, exiting' && exit

mv .msgid .msgid.bak

echo "Working on $1..."
cat $1 | formail -D 8192 .msgid -s >> dedupe.mbox

mv -f dedupe.mbox $1