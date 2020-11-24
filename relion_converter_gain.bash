#! /bin/bash
echo "$1 to watch"
echo $3
#inotifywait -t 120 --event close_write --event moved_to --format '%w%f' $1 | while read FILE
inotifywait -t 10 --format '%e %w%f' $1 | while read EVENT FILE
do
  echo "$FILE written $EVENT"
  if [[ "$FILE" =~ .*mrc$ ]]; then
    file_name=$(basename $1)
    directory=${1%"$file_name"} 
    cd $directory
    relion_convert_to_tiff --i "$file_name" --gain $4  --o "$3"
    #mv ${FILE:0:-3}tif $2
  fi
done
