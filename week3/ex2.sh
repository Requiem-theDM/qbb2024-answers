#!/usr/bin/env bash

### Question 2.1 ###
wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
gunzip sacCer3.fa.gz
bwa index sacCer3.fa

less sacCer3.fa.amb
# There are 17 chromosomes in the file.

#Scans through every fastq file from the A01 series.
for NUMERIC in 09 11 23 24 27 31 35 39 62 63
do
    FILE=A01_${NUMERIC}.fastq
    echo ${FILE}
    #Run bwa mem to perform alignment of each file.
    bwa mem -t 4 -R "@RG\tID:A01_${NUMERIC}\tSM:A01_${NUMERIC}" sacCer3.fa ${FILE} > sacCer_A01_${NUMERIC}.sam 
    #Creates a sam file of alignments, and its corresponding binary file
    samtools sort -@ 4 -O bam -o sacCer_A01_${NUMERIC}.bam sacCer_A01_${NUMERIC}.sam 
    #Indexes each bam file for later
    samtools index sacCer_A01_${NUMERIC}.bam
done

### Question 2.2 ###
bc -e "$(wc -l sacCer_A01_09.sam | cut -b 1-9) - 20" #Takes the length of the sam file, minus the 20 header lines.

# There are 669548 alignments in the file.


### Question 2.3 ###
grep -w "chrIII" sacCer_A01_09.sam | wc -l #Finds any line containing chrIII as a word, then counts them.

# There are 18196 alignments to chromosome 3.


### Question 2.4 ###

# Broadly yes, though the coverage is far from uniform in its distribution.


### Question 2.5 ###

# Three SNPs are visible, however the putative SNP at chrI:113,326 only is covered by two reads, thus it is more likely to be an artifact of sequencing than the other two SNPs which are covered by four reads.


### Question 2.6 ###

# The SNP is located at chrIV:825,834. It occurs in the intergenic region between SCC2 and SAS4.