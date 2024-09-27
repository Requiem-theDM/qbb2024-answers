#!/usr/bin/env python3

#Establishes environment
import sys

import numpy

import re

vcf_raw = open(sys.argv[1])

allele_freq = [] #Initialize a list to hold allele frequencies
depth_dist = [] #Initializes a list to hold

#Skips the first 77 lines of metadata
for i in range(77): 
    vcf_raw.readline() 

header = vcf_raw.readline().rstrip("\n").split("\t") #Pulls the header from the 78th line of metadata
info_pos = header.index("INFO") #Locates the column with info based off of its column in the header
format_pos = header.index("FORMAT") #Locates the column with format based off of its column in the header

#Locate the column with info for each member of the A01 series and store it into a list
A01_series = [header.index("A01_09"),
              header.index("A01_11"),
              header.index("A01_23"),
              header.index("A01_24"),
              header.index("A01_27"),
              header.index("A01_31"),
              header.index("A01_35"),
              header.index("A01_39"),
              header.index("A01_62"),
              header.index("A01_63")
]

#Reads the data of the vcf file line by line
for line in vcf_raw:
    fields = line.rstrip('\n').split('\t')
    info = fields[info_pos]
    allele_freq.append(info.split(";")[info.split(";").index([i for i in info.split(";") if re.findall(r'^AF=',i)][0])]) #Splits the info field at semicolons, locates allele frequency based off of its designator, then appends it to the list of frequencies.
    for column in A01_series: #Scans through each column of the samples
        depth_dist.append(fields[column].split(":")[fields[format_pos].split(":").index("DP")]) #Uses the format column to determine the index to pull read depth from a given sample

with open(f"AF.txt", "w") as file:
    file.write("Allele_Frequency\n")
    for frequency in allele_freq:
        file.write(f"{frequency[3:]}\n")

with open(f"DP.txt", "w") as file:
    file.write("Read_Depth\n")
    for depth in depth_dist:
        file.write(f"{depth}\n")

vcf_raw.close()