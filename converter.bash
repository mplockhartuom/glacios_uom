#! /bin/bash

#echo Path to project directory
#read project_directory

inotifywait -mr . --event close_write --format '%w%f' . | while read FILE
do
  echo "$FILE written"
  if [[ "$FILE" =~ .*mrc$ ]]; then
    /usr/local/IMOD/bin/mrc2tif -c lzw -s $FILE ${FILE:0:-3}tif
    mv ${FILE:0:-3}tif /home/mplockhart/windows/watch_folder/glacios_uom/tif
  fi
done
