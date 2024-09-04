#!/bin/bash

# Run this command to make a file executable: chmod +x "FileName" 

# Unix stores command line arguments in $0, $1
echo "0th:" $0
echo "1st:" $1

#Cut the first column, in the 0 indexed position, then sort, count, and organize the data.
cut -f 1 $1 > column.txt
sort column.txt | uniq -c | sort -n -r