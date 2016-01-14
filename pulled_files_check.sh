#!/usr/bin/env bash

# @author Ola Ajibode
# Filename: profile_files.sh
# Sanity test for Geo data on S3

# USAGE:  ./profile_files.sh
#To check how long it takes to perform sanity check: time ./profile_files.sh

# ALGORITHM ---TODO: delete Algo once done
# Get files from S3 bucket - TODO: aws-cli manually used.  Script is available at the end of this script.
# Unzip all .gz files - TODO: Done
#Check if files are UTF-8 encoded TODO: Done
# Get list of all files in the directory TODO: Done
# Add list to empty array  TODO: Done
# iterate over list checking TODO: Done
#   - size of file is greater than 0 TODO Done
#   - content is more than just a single header - should have content TODO Done
#   - check each row has the same number of columns TODO Done

# Exit the loop and return 0 or zero if no failure TODO: Done
#   - No failures at all returns success TODO: Done
#   - If any file fails then return a failure TODO: Pending

#Setup your machine with these commandline Tools for TESTING
#sudo pip3 install --upgrade setuptools
#sudo pip3 install --upgrade csvkit
#Mac OSX: brew install moreutils
#Debian - Ubuntu: sudo apt-get install moreutils

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

PACKAGES="csv"
PACKAGES="tsv"
PACKAGES="csvkit"

#####################################################
#                                                   #
#           HELPER FUNCTIONS                        #
#                                                   #
#####################################################

cleanup_file() {
    if [ -f $1 ]; then
        rm $1
    else
        :
    fi
}

read_file() {
    filename="$1"
    while read -r line
    do
        name=$line
        return $name
    done < "$filename"
}

line_count() {
    n=`wc -l $1 | awk '{print $1}'`
    echo $n
}

validate_headers() {
    arr_1=$1
    arr_2=$2
    [ "${arr_1[*]}" == "${arr_2[*]}" ] && echo "equal" || echo "distinct"
}

#Current machine operating system
get_machineOS() {
    os=`uname -s`
    if [ "$os" == "Darwin" ]; then
        echo "MacOS"
    elif [ "$os" == "Linux" ]; then
        echo "Linux"
    else
        echo "UnKnown"
    fi
}

#####################################################
#                                                   #
#       S3 FILES GETTER (awscli tool)               #
#                                                   #
#####################################################

# if dirs do not exists:    mkdir boxed/ unboxed/
# aws s3 sync s3://<location_on_s3>/geodata/ .

################ SETUP  FILES  ##################
#                                               #
#   CLEAN EXISTING TEST ARTIFACTS               #
#                                               #
#################################################

cleanup_file gzlist.csv
cleanup_file gaia_split.csv
cleanup_file test_report.csv
cleanup_file columns_report.tsv
#cleanup_file headers_ok.csv
#cleanup_file headers_faulty.csv
cleanup_file processed_files.csv
cleanup_file file_stats.csv

#Catch all Cleanup
rm *.tsv
rm *.csv.csv
#rm *.csv #switch on once S3 files are no longer suffixed with .csv.gz

touch test_report.tsv
touch columns_report.tsv
#touch headers_ok.csv
#touch headers_faulty.csv

#if history.csv does not exists, create it
#touch history.csv

############################################
#                                          #
#    PROCESSING STARTS                     #
#                                          #
############################################

# Unpack all .gz files in current directory
zipped=`ls -a *.gz > gzlist.csv | wc -l`

gzcount=`line_count gzlist.csv`

declare -a gaia_gzips
readarray gaia_gzips < gzlist.csv

#If .gz corruption is false, continue
for z in "${gaia_gzips[@]}"
do
    gunzip -t $z
done

#Verify .gz files exist
if [ "$gzcount" -gt 0 ]; then
    gzip -d *.gz
else
    :
fi

#gunzip *.gz
# Check if any file is empty.  Empty return means all contain some
ls -l | awk 'NF < 2 {print $6 }'

#Get the list of all file in current directory
ls | grep -Ev '\.(sh|tsv|.java|rb|properties|txt)$' | column > gaia_split.csv
s3_file_count=`line_count gaia_split.csv`

# Read gaia_split.csv and create an array of names
declare -a gaia_names
readarray gaia_names < gaia_split.csv

gaia_names_size=`echo ${#gaia_names[*]}`

echo "=============== SANITY TEST REPORT ===============" >> test_report.tsv
echo $(date) >> test_report.tsv
echo $(date +%s) >> test_report.tsv
echo " FILES PROCESSED: $s3_file_count" >> test_report.tsv
echo "------------  LAST IMPORT INFO -------------------" >> test_report.tsv
printf "\n" >> test_report.tsv
echo $(tail -3 import_state.properties | head -1) >> test_report.tsv
echo $(tail -2 import_state.properties | head -1) >> test_report.tsv
echo $(tail -1 import_state.properties | head -1) >> test_report.tsv
printf "\n" >> test_report.tsv
echo "---------------------------------------------------" >> test_report.tsv
echo "filename,header_columns,total_records, file_encoding" >> test_report.tsv
#echo "filename,header_columns, unique_row_columns, total_records, file_encoding" >> test_report.tsv
echo "filename,header_columns, unique_row_columns" >> columns_report.tsv
machineOS=`get_machineOS`

#check each file: headers, count columns in each row, count total number of record
for i in "${gaia_names[@]}"
do
#Default file -i or file -I is not 100% accurate
    #    if [ "$machineOS" == "MacOS" ]; then
    #        f_encode=`file -I $i | grep -o 'charset.*'`
    #    else
    #        f_encode=`file -i $i | grep -o 'charset.*'`
    #    fi
    isutf8 $i
    n_coding=$?
    if [[ $n_coding -eq 0 ]]; then
        f_encode=`echo UTF8`
    else
        f_encode=`echo nonUTF8`
    fi

    fname=`printf $i`
    #    touch $fname.csv
    echo $fname >> processed_files.csv

    hd=`awk -F',' '{ print NF }' $i | head -n 1`
    cols=`awk -F',' '{ print NF }' $i | uniq -c`
    rws=`line_count $i`
    str=$i","$hd","$rws","$f_encode
    col_rep=$i","$hd","$cols
    echo $col_rep >> columns_report.tsv

    echo $str >> test_report.tsv
    echo $(less $i | head -n 1 | awk -F',' '{ print $0,$NF }') > $fname

    printf "%s\n $i"
    #    Check each row for column consistency
    csvclean -n $i
    csvcut -n $i
#    read_file $fname
    echo $(csvstat $i) | csvlook >> file_stats.csv
done

# awk -F',' '{ print $NF }' test_report.tsv # awk -o -F'\t' '{ print NF }' > column_checker.csv

cat test_report.tsv | csvlook >> test_summary.tsv
cat columns_report.tsv | csvlook >> records_view.tsv
cat processed_files.csv | csvlook
cat test_report.tsv | csvlook
#rm test_report.tsv

#OTHER USEFUL TOOLS
#jq --JSON bash formatter
#json2csv --https://github.com/jehiah/json2csv
#xml2json --https://github.com/parmentf/xml2json
#time csvsql -i sqlite geo_target-20151208112720114 -- create sql schema of data #verify data types

#Performs a Word count on file content
# Use:  cat file.ext | ./file_content.sh 200
#NUM_LINES=$1
#tr '[:upper:]' '[:lower:]' | grep -oE '\w+' | sort | uniq -c | sort -nr | head  -n $NUM_LINES

