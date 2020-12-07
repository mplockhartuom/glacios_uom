#!/bin/bash

dir=/home/mqbpkml3/em/sandbox/None

#echo "Path to collection directory: "
#read collection_dir
if [[ -d $dir]] 
then
  echo "$dir exists"
else  
  echo "###################################"
  echo "#                                 #"
  echo "#  That is not a real directory.  #"
  echo "#                                 #"
  echo "###################################"
  exit
fi
