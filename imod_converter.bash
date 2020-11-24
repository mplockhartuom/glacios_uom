#! /bin/bash
echo "$1 to watch"
#inotifywait -t 120 --event close_write --event moved_to --format '%w%f' $1 | while read FILE
inotifywait -t 120 --format '%e %w%f' $1 | while read EVENT FILE
do
  echo "$FILE written $EVENT"
  if [[ "$FILE" =~ .*mrc$ ]]; then
    `which mrc2tif` -c lzw -s $FILE ${FILE:0:-3}tif
    mv ${FILE:0:-3}tif $2
  fi
done
