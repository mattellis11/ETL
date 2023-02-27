#!/bin/bash
# Name: Matt Ellis
# Date: 06/25/22
# Semester Project

#****************************************************************************************
# Script Purpose
# This script imports a file, uncompresses the file, preprocesses
# the data (clean the data), sums the transaction total for each customer, and
# generates a report with a summary for each customer.
#****************************************************************************************

# Err Handling
set -o errexit # exit if an error occurs
set -o pipefail # exit if error occurs during pipes

# Server IP Address: 40.69.135.45
# Source file name and location: /home/shared/MOCK_MIX_v2.1.csv.bz2

# Checks for required number of args
if (( $# != 3 )); then
    echo "Usage: $0 [Server IP Address] [Server User ID] [Full-Path Of Source File]"
    exit 1
fi

# Declare variables
remote_server_usrid="$2"
remote_server="$1"
src_file_path="$3"
src_file_compressed="${src_file_path##*/}"
src_file_extracted="${src_file_compressed%.*}"

# Import file from remote server
scp -q $remote_server_usrid@$remote_server:$src_file_path .

# check for errors on file transfer
if (( $? != 0 ))
    then
        echo "An error has occured. Please verify your inputs(server name, user id , file path) are correct."
        echo "Exiting the program."
        exit 1
    else
        echo "$src_file_compressed transfered successfully. File transfer -- complete. "
fi

# Extract source file
bunzip2 $src_file_compressed

# check for errors on extraction
if (( $? != 0 ))
    then
        echo "An error has occured while decompressing the source file."
        echo "Make sure the source file is compressed using bzip2."
        echo "Exiting the program."
        exit 1
    else
        echo "File extraction -- complete."
fi

#****************************************************************************************
# Clean up and prepare data section
# Tasks:
#   1) Remove the file header. Then convert all the text to lower case.
#   2) Standardize the "gender" field
#   3) Remove entries with improper state field into a separate file(exceptions.csv)
#   4) Remove the dollar sign from the purchase amount field                
#   5) Place results in file(clean_data.tmp).
#****************************************************************************************

# Remove the file header from source file. Then convert all the text to lower case.
tail -n +2 "$src_file_extracted" | tr [:upper:] [:lower:] > 01_no_head_lower.tmp

# Clean up and prepare data.
awk -f scripts/_data_clean.awk 01_no_head_lower.tmp

# Sort cleaned data by customerID
sort -t "," -k 1 02_data_cleaned.tmp > transaction.csv
echo "Data cleaned and processed. Valid transactions recorded in transaction.csv."

#*******************************************************************************************
# Generates a summary report using the transaction.csv file. 
#   1) Accumulates the total purchase amount for each ”customerID”
#   2) Produces a new comma delimited file(summary.tmp) with a single record per customerID
#      and the total amount over all records for that customer.
#      The fields in this file:
#        1. customerID
#        2. state
#        3. zip
#        4. lastname
#        5. firstname
#        6. total purchase amount
#*******************************************************************************************
awk -f scripts/_gen_report.awk transaction.csv

#*******************************************************************************************
# Sorts the summary file based upon (priority by order in list):
#   1. state
#   2. zip (decending order)
#   3. lastname
#   4. firstname
# The final summary file is summary.csv.
#*******************************************************************************************
sort -t "," -k 2,2 -k 3,3nr -k 4,4 -k 5,5 < summary.tmp > summary.csv
echo "Generating summary report..."
echo "Summary -- complete"
echo "Transaction summary for each customer recorded in summary.csv."

# clean up temporary files
rm -f 01_no_head_lower.tmp 02_data_cleaned.tmp summary.tmp

exit 0