# upload those files only which is not on telegram from search directory
echo "--------------------------------------------------------------------"
echo "Enter username, leave blank if you want to save in savedmessages!!"
echo "--------------------------------------------------------------------"
read user_name
user="${user_name:=me}"
echo "--------------------------------------------------------------------"
echo "Enter search directory: "
echo "--------------------------------------------------------------------"
read search_dir
maxsize=34
divisor=2
cond=1
count=0
echo "--------------------------------------------------------------------"
echo "Enter folder name: (leave blank to continue on same folder)" 
echo "--------------------------------------------------------------------"
read folder_name
echo "--------------------------------------------------------------------"
echo "Do you want to give caption? y or n (by default yes)"
echo "--------------------------------------------------------------------"
read iscaption
echo "--------------------------------------------------------------------"
iscaption="${iscaption:=y}"
yes="y"
no="n"
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
  size_dir=${#search_dir}
  #caption we are fetching using substring
  caption=${path:$size_dir+1}
  searchOutput=$(tginfo -n MohitCloud -u me -s "$caption")
  num=${searchOutput:0:1}
  if [ $num -eq 0 ]
  then
  echo "--------------------------------------------------------------------"
  echo "$caption is uploading!!"
  echo "--------------------------------------------------------------------"
  count=$count+1
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
done