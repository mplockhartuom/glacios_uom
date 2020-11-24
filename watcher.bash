#! /bin/bash

clear

echo "Which mode are you collecting in, Linear or Counting? [L/C]"
read collection_mode

if [ "${collection_mode,,}" == "l" ] || [ "${collection_mode,,}" == "linear" ] ; then
  echo "You have selected Linear mode"
  echo "Path to collection directory: "
  read collection_dir
  echo "Path to destination directory: "
  read dest_dir
elif [ "${collection_mode,,}" == "c" ] || [ "${collection_mode,,}" == "counting" ] ; then
  echo "You have selected Counting mode."
  echo "Path to collection directory: "
  read collection_dir
  echo "Path to destination directory: "
  read dest_dir
  echo "Path to gain image (inclusive of the .mrc file): "
  read gain_image
  echo "Moving gain to destination folder"
  echo "clip flipx $gain_image (date +%Y%m%d)_gain_flipx.mrc"
  echo "rsync -aPhzv *gain_flipx.mrc $dest_dir"

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

inotifywait -mr --event create --event moved_to --format '%e %w%f' $collection_dir | while read ACTION FILE
do
  echo "$FILE triggered with $ACTION"
  if [[ "$FILE" =~ .*mrc$ ]]; then
    if [[ "$ACTION" = "MOVED_TO"  ]] ; then
      . ./imod_do_conv.bash $FILE $dest_dir &
    else 
      . ./imod_converter.bash $FILE $dest_dir &
    fi
  fi
done