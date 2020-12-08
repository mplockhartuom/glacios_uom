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



# Make a list of existing mrc files and start converting them

###
### Clean this section up
###
current_dir=$PWD
cd $collection_dir

if [[ "ls *.mrc"  < "5" ]] ;
	then
	sleep 10
	echo "Waiting for gain"
fi

ls */*/*.mrc | head -5 > 5_files_gain.lst
relion_convert_to_tiff --i 5_files_gain.lst --estimate_gain --o $dest_dir

gain_estimate=$dest_dir/gain_estimate.bin

ls *.mrc > existing_files.lst
relion_convert_to_tiff --i existing_files.lst --gain $gain_estimate --o $dest_dir --only_do_unfinished &
cd $current_dir

# start running the watching script for new  Linear file format files.
inotifywait -mr --event create --event moved_to --format '%e %w%f' $collection_dir | while read ACTION FILE
  do
    echo "$FILE triggered with $ACTION"
    if [[ "$FILE" =~ .*mrc$ ]]; then
      if [[ "$ACTION" = "MOVED_TO"  ]] ; then
    . ./relion_do_conv_gain.bash $FILE $collection_dir $dest_dir &
    else 
      . ./relion_converter_gain.bash $FILE $collection_dir $dest_dir &
      fi
    fi
  done
