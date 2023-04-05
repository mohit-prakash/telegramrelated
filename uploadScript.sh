# upload all files in a search directory
echo "Enter username, leave blank if you want to save in savedmessages!!"
read user_name
user="${user_name:=me}"
echo "Enter search directory: "
read search_dir
maxsize=34
divisor=2
cond=1
echo "Enter folder name: "
read folder_name
echo "Do you want to give caption? y or n"
read iscaption
yes="y"
no="n"
#MAX allowed folder name size 34 chars
fname_size=${#folder_name}
star="*"
prefix=" "
suffix=" "
presize=$((maxsize-fname_size))
presize=$((presize/divisor))
while(( $presize>=$cond ))
do
  prefix=$star$prefix
  suffix=$suffix$star
  presize=$((presize-cond))
done
dir_name=$prefix$folder_name$suffix
tgsend -n MohitCloud -u "$user" {"${dir_name}",,}
for entry in "$search_dir"/*
do
  path=$entry
  size_dir=${#search_dir}
  if [ $iscaption == $yes ]
  then
    caption=${path:$size_dir+1}
    tgcloud --mode upload --name MohitCloud --username "$user" --path "$path" --caption "$caption"
  else
    tgcloud --mode upload --name MohitCloud --username "$user" --path "$path"
  fi
done