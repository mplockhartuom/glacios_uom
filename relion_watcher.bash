#! /bin/bash


echo "Which mode are you collecting in, Linear or Counting? [L/C]"
read collection_mode

if [ "${collection_mode,,}" == "l" ] || [ "${collection_mode,,}" == "linear" ] ; then
  echo "You have selected Linear mode"
  echo "Path to collection directory: "
  read collection_dir
  echo "Path to destination directory: "
  read dest_dir

  # start running the watching script for new  Linear file format files.
  inotifywait -mr --event create --event moved_to --format '%e %w%f' $collection_dir | while read ACTION FILE 
    do
      echo "$FILE triggered with $ACTION"
      if [[ "$FILE" =~ .*mrc$ ]]; then
        if [[ "$ACTION" = "MOVED_TO"  ]] ; then
          . ./relion_do_conv.bash $FILE $collection_dir $dest_dir &
        else 
          . ./relion_converter.bash $FILE $collection_dir $dest_dir &
        fi
      fi 
    done

elif [ "${collection_mode,,}" == "c" ] || [ "${collection_mode,,}" == "counting" ] ; then
  echo "You have selected Counting mode."
  echo "Path to collection directory: "
  read collection_dir
  echo "Path to destination directory: "
  read dest_dir
  echo "Path to gain image (inclusive of the .mrc file): "
  read gain_image
  echo "Moving gain to destination folder"
  echo "clip flipx $gain_image gain_flipx.mrc"
  gain_flipped="gain_flipx.mrc"
  echo "rsync -aPhzv *gain_flipx.mrc $dest_dir"

  # start running the watching script for new  Linear file format files.
  inotifywait -mr --event create --event moved_to --format '%e %w%f' $collection_dir | while read ACTION FILE
    do
      echo "$FILE triggered with $ACTION"
      if [[ "$FILE" =~ .*mrc$ ]]; then
        if [[ "$ACTION" = "MOVED_TO"  ]] ; then
      . ./relion_do_conv_gain.bash $FILE $collection_dir $dest_dir $gain_flipped &
      else 
        . ./relion_converter_gain.bash $FILE $collection_dir $dest_dir $gain_flipped &
        fi
      fi
    done
  
else  
  echo "###################################"
  echo "#                                 #"
  echo "#   That is not a valid option.   #"
  echo "#   Enter L or C.                 #"
  echo "#  Please close and start again.  #"
  echo "#                                 #"
  echo "###################################"
  exit
fi

