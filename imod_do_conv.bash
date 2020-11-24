#! /bin/bash
if [[ "$FILE" =~ .*mrc$ ]]; then
    `which mrc2tif` -c lzw -s $FILE ${FILE:0:-3}tif
    mv ${FILE:0:-3}tif $2
fi
