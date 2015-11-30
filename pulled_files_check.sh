#!/bin/bash
# @author Ola Ajibode 
# Sanity test for pulled data on S3

# USAGE:  ./pulled_files_check.sh 

# ALGORITHM
# Get files from S3 bucket - Pending poc - s3cmd?
# Unzip all .gz files - done
# Get list of all files in the directory -done
# Add list to empty array
# iterate over list checking 
#   - size of file is greater than 0
#   - content is more than just a single header - should have content
#   - check each has the same number of columns

# Exit the loop and return 0 or zero depending on any failure
#   - No failures at all returns success
#   - If any file fails then return a failure

check_for_file(){
if [ -f $1 ];then
   echo "$1 exists. Deleting now. "
   rm $1
else
   echo "File $1 does not exists. "
fi
}

# Clean existing pulled test check file
check_for_file pulled_split.tsv

# Unpack all .gz files in current directory
# if [  `ls -l .gz | wc -l` > 0 ]; then
if [  -f *.gz ]; then
	echo ".gz files exist...."
	gunzip *.gz
else
exit[0]
fi

# Check if any file is empty.  Empty return means all contain some
ls -l | awk 'NF < 1 {print $10 }'

#Get the list of all file in current directory
`ls >> pulled_split.tsv`
filecount=`wc -l pulled_split.tsv`
echo $filecount
t=$(du -h pulled_split.tsv)
echo $t
# Confirm you have file in directory
# s=$(wc -l pulled_split.tsv)
# test $s -ge 1;
cat pulled_split.tsv
# Read pulled_split.tsv and create an array of names

read_catalogue(){
while IFS='' read -r line || [[ -n $line ]]; do
 echo "$line"
done < $1
}
declare -a pulled_names
read_catalogue pulled_split.tsv >> ${pulled_names}

#check is each file contains more than the headers
for i in "${pulled_names[@]}"
do
test $(sed 2q $i) -ge 1;
done

# Read the late bulk import
$(cat import_state.properties > bulkCheck.tsv)

#for v in 'cat pulled_split.tsv'; do echo v; done

awk -F',' '{print NF; exit }' pulled_split.tsv

#awk 'FNR==NR {arr[$0];next} $1 in arr' last_summary.csv current_summary.csv > diffList.csv
$(touch last_bulk.tsv current_check.tsv )
awk 'FNR==NR{a[$2];next}!($2 in a)' last_bulk.tsv current_check.tsv > status.tsv


