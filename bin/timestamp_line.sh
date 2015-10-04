#!/usr/local/bin/bash

## $Id: timestamp_line.sh,v 1.1.1.1 2010/08/14 04:57:50 wdr1 Exp $

FILE=$1
DATE=`date "+=== %a, %b %e %Y ==="`

LAST_LINE=`tail -1 $FILE`

#echo "DATE: $DATE"
#echo "LL: $LAST_LINE"

OUTPUT=`grep "$DATE" $FILE`
echo "OUTPUT: $OUTPUT"

if [[ "z$OUTPUT" == "z" ]]
then
    echo "$DATE" >> $FILE
fi    