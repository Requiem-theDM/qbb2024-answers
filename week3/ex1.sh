#!/usr/bin/env bash

### Question 1.1 ###
wget https://www.dropbox.com/s/ogx7nbhlhrp3ul6/BYxRM.tar.gz
tar -xvzf BYxRM.tar.gz
READLENGTH=$(head -n 2 A01_09.fastq | tail -n 1 | awk '{print length}') #Takes the second line of the file, then counts its length with awk

# The sequencing reads are 76 bp in length.


### Question 1.2 ###
LINECOUNT=$(wc -l A01_09.fastq | cut -b 1-8) #Counts the number of lines in the file and keeps only that number.
READCOUNT=$(bc -l -e "${LINECOUNT} / 4") #Counts the number of reads by dividing by 4 for each read having a label, quality score, and a separator line in addition to its sequence.

# There are 669548 reads in the file.


### Question 1.3 ###
GENOMELENGTH=$(wc -m sacCer3.fa | cut -b 1-9) #Takes the character length of the s. Cerevisiae genome and keeps only that number.
COVERAGE=$(bc -l -e "${READCOUNT} * ${READLENGTH} / ${GENOMELENGTH}") #Uses the calculated variables to figure out coverage.

# The expected coverage is 4x.


### Question 1.4 ###
echo -n "" > fastq_file_sizes.txt #Initializes a file for storing found file sizes.
for NUMERIC in 09 11 23 24 27 31 35 39 62 63 #Scans through every fastq file from the A01 series.
do
    FILE=A01_${NUMERIC}.fastq
    FILESIZE=$(du -h ${FILE}) #Determines the file size in a human readable manner
    echo -e "${FILESIZE}" >> fastq_file_sizes.txt #Appends the found file size into a text file for reading
done 
less fast1_file_sizes.txt #Opens the generated text file to read through and find the largest/smallest file sizes.

# The A01_62 sample has the largest file size at 149 MB, the A01_27 sample has the smallest file size at 110 MB.

### Question 1.5 ###
FastQC *.fastq

# The median base quality on the read is 37.
# This means that the probability of any base being an error is 10e-3.7.
# The variability of quality seems to increase at both ends of a given read.