#! /bin/bash
if [[ "$FILE" =~ .*mrc$ ]]; then
    file_name=$(basename $1)
    directory=${1%"$file_name"} 
    cd $directory
    relion_convert_to_tiff --i "$file_name"  --o "$3"
    #mv ${FILE:0:-3}tif $2
fi
