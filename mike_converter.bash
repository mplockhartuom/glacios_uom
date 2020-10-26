#! /bin/bash

echo "Set data path"
read DATA_DIR

echo "Set destination path"
read DESTINATION_DIR


inotifywait -mr  -e create --format '%w%f' $DATA_DIR | while read FILE
do
    echo "$FILE" written
    if [[ "$FILE" =~ .*mrc$ ]]; then
        while [[ "$(ls -l --full-time $FILE)" != "$a" ]] 
            do a=$(ls -l --full-time $FILE)
            sleep 0.5
                done
            /usr/local/IMOD/bin/mrc2tif -c lzw -s $FILE ${FILE:0:-3}tif
                mv ${FILE:0:-3}tif $DESTINATION_DIR
            fi
    done

