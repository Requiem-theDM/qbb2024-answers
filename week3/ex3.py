#!/usr/bin/env python3

#Establishes environment
import sys
import numpy
import re

allele_freq = [] #Initialize a list to hold allele frequencies
depth_dist = [] #Initializes a list to hold

#Reads the data of the vcf file line by line
for line in open(sys.argv[1]):
    if line.startswith('##'):
        continue #Skips all metadata lines except the header
    if line.startswith('#'):
        header = line.rstrip("\n").split("\t") #Pulls the header from the last line of metadata
        info_pos = header.index("INFO") #Locates the column with info based off of its column in the header
        format_pos = header.index("FORMAT") #Locates the column with format data based off of its column in the header
        sample_pos = list(range(len(header[:format_pos + 1]),len(header))) #Locate the column with info for each sample and store it into a list
    else:
        fields = line.rstrip('\n').split('\t')
        allele_freq.append(fields[info_pos].split(";")[fields[info_pos].split(";").index([i for i in fields[info_pos].split(";") if re.findall(r'^AF=',i)][0])]) #Pulls the info field based on the header, splits the info field at semicolons, locates allele frequency based off of its designator, then appends it to the list of frequencies.
        for sample in sample_pos: #Scans through each column of the samples
            depth_dist.append(fields[sample].split(":")[fields[format_pos].split(":").index("DP")]) #Uses the format column to determine the index to pull read depth from a given sample

with open(f"AF.txt", "w") as file:
    file.write("Allele_Frequency\n")
    for frequency in allele_freq:
        file.write(f"{frequency[3:]}\n")

with open(f"DP.txt", "w") as file:
    file.write("Read_Depth\n")
    for depth in depth_dist:
        file.write(f"{depth}\n")