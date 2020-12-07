#! /bin/bash

echo "Path to collection directory: "
read collection_dir
if [[ -d $collection_dir ]] 
then
  echo "$collection_dir exists"
else  
  echo "###################################"
  echo "#                                 #"
  echo "#  That is not a real directory.  #"
  echo "#  Please start again by pasting  #"
  echo "#  the following code into the    #"
  echo "#           terminal              #"
  echo "#                                 #"
  echo "#      bash relion_watcher        #"
  echo "#                                 #"
  echo "###################################"
  exit
fi

echo "Path to destination directory: "
read dest_dir
if [[ -d $dest_dir ]] 
then
  echo "$dest_dir exists"
else  
  echo "###################################"
  echo "#                                 #"
  echo "#  That is not a real directory.  #"
  echo "#                                 #"
  echo "###################################"
  exit
fi
echo "Path to gain image (inclusive of the .mrc file): "
read gain_image

if [[ -f $gain_image ]] 
then
  echo "$gain_image exists"
else  
  echo "###################################"
  echo "#                                 #"
  echo "#    That is not a real file.     #"
  echo "#                                 #"
  echo "###################################"
  exit
fi
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
    . ./relion_do_conv_gain.bash $FILE $collection_dir $dest_dir $gain &
    else 
      . ./relion_converter_gain.bash $FILE $collection_dir $dest_dir $gain &
      fi
    fi
  done
  


