#!/bin/bash
#@author Ola Ajibode 
# Sanity test for daily summary files downloaded from S3 bucket
# Sorts daily summary file and compares the values in the first row to known values

# USAGE:  ./monthend_sanity_test.sh currentMonth_summary.csv lastMonth_summary.csv 20150228

#To use this script, place script in same directory as concatenated S3 files - daily summaries
#Also ensure that the daily_summary csv is also present in the same directory

mkdir backup
cp *.* backup/

currentMonth=$1 #daily summary for current month e.g feb 2013
lastMonth=$2 #daily summary file for previous month e.g. jan 2013
lastDateCurrentMonth=$3 #last day of month being processed in the format yyyyMMdd e.g. 20130228

echo $(date)

check_for_file(){
if [ -f $1 ];then
   echo "$1 exists.  Deleting now. "
   rm $1
else
   echo "File $1 does not exists. "
fi
}

#Setup: if test output files exists, delete or else do nothing
check_for_file current_summary.csv #current month
sort -k1,1 $currentMonth > current_summary.csv
head current_summary.csv  #remove once testing is complete

check_for_file last_summary.csv #last_month
sort -k1,1 $lastMonth > last_summary.csv
head last_summary.csv #remove once testing is complete

check_for_file diffList.csv #list of differences file. No comparison yet.

#awk 'FNR==NR {arr[$0];next} $1 in arr' last_summary.csv current_summary.csv > diffList.csv
awk 'FNR==NR{a[$2];next}!($2 in a)' last_summary.csv current_summary.csv > diffList.csv

if [ -f diffList.csv ];then
	s=$(du -h diffList.csv)
    echo "file size: $s "
if [ "$s" != "0B diffList.csv " ];	then #BUG:  returning message when file size is 0B!
   		echo "Check differences in diffList.csv.  Latest month's top 10 lines: "
   		head diffList.csv
   	else
   	echo "BUG 1: No differences!.  Data for most recent month is missing! "
   	fi
else
	echo "BUG 2: No differences!.  Data for most recent month is missing! "
fi
echo $(date)
if grep -q "$lastDateCurrentMonth" current_summary.csv
then
    echo "Last day of current month is present.  Please still check manually."
else
    echo "Last day of current month is missing.  BUG? Check file now!"
fi
