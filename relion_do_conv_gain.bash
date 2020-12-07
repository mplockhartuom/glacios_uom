#! /bin/bash
if [[ "$FILE" =~ .*mrc$ ]]; then
    sleep 30
    file_name=$(basename $1)
    directory=${1%"$file_name"} 
    cd $directory
    relion_convert_to_tiff --i "$file_name" --gain "$4" --o "$3"
    #mv ${FILE:0:-3}tif $2
fi
