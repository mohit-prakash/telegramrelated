# This script will upload all files in a directory.
# And also upload all files if there is any other folder also.
# By default it will get uploaded to saved message 
user="me"
searchDir=$(pwd)

uploadFilesInsideDirectory() {
search_dir=$1
parentdir="$(dirname "$search_dir")"
parentdirSize=${#parentdir}
maxsize=34
divisor=2
cond=1
count=0
index=0
dotIndex=0
dot="."
iscaption="${iscaption:=y}"
yes="y"
no="n"
isFolderExistInThisFolder="n"
folder_name=${search_dir:parentdirSize+1}
#MAX allowed folder name size 34 chars
fname_size=${#folder_name}
star="*"
prefix=" "
suffix=" "
presize=$((maxsize-fname_size))
presize=$((presize/divisor))
if [ $fname_size != 0 ]
then
while(( $presize>=$cond ))
do
  prefix=$star$prefix
  suffix=$suffix$star
  presize=$((presize-cond))
done
dir_name=$prefix$folder_name$suffix
fi
for entry in "$search_dir"/*
do
  path=$entry
  if [ -d $path ]
  then
    isFolderExistInThisFolder="y"
  else
  size_dir=${#search_dir}
  #caption we are fetching using substring
  caption=${path:$size_dir+1}
  captionSize=${#caption}
  dotIndex=$captionSize
  while(( $index<$captionSize ))
  do
    if [ ${caption:$index:1} == $dot ]
    then
      dotIndex=$index
    fi
    index=$(( $index + 1 ))
  done
  fileName=${caption:0:$dotIndex}
  searchOutput=$(tginfo -n MohitCloud -u "$user" -s "$fileName")
  num=${searchOutput:0:1}
  if [ $num -eq 0 ]
  then
  echo "--------------------------------------------------------------------"
  echo "$caption is uploading!!"
  echo "--------------------------------------------------------------------"
  count=$(( $count + 1 ))
  if [[ $count -eq 1  && $fname_size != 0 ]]
  then
    tgsend -n MohitCloud -u "$user" {"${dir_name}",,}
  fi
  if [ $iscaption == $yes ]
  then
    tgcloud --mode upload --name MohitCloud --username "$user" --path "$path" --caption "$caption"
    echo "--------------------------------------------------------------------"
    echo "$caption uploaded successfully!!"
    echo "--------------------------------------------------------------------"
  else
    tgcloud --mode upload --name MohitCloud --username "$user" --path "$path"
    echo "--------------------------------------------------------------------"
    echo "$caption uploaded successfully!!"
    echo "--------------------------------------------------------------------"
  fi
  else
    echo "$caption already exist!!"
  fi
  fi
done
if [ $isFolderExistInThisFolder == $yes ]
then
for entry in "$search_dir"/*
do
  if [ -d $entry ]
  then
    uploadFilesInsideDirectory $entry
  fi
done
fi
}

uploadFilesInsideDirectory $searchDir