#!/usr/bin/env python3

#Establishes environment
import sys

import numpy

gene_tissue = open(sys.argv[1]) #Make sure you load gene_tissue.tsv

#Makes a dictionary to hold samples for gene and tissue pairs
relevant_samples = {}

for line in open(sys.argv[1]):
    #Removes any extraneous line returns from the right end of lines, splits each line at tabs, and stores the resulting list into the variable "fields"
    fields = line.rstrip("\n").split("\t")
    #Takes the gene id and tissue to make a key:value pair
    key = fields[0]
    value = fields[2]
    #Initializes the dictionary with lists for holding samples
    relevant_samples.setdefault(key,value)

metadata = open(sys.argv[2]) #Make sure you load GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt
metadata.readline()

#Makes a dictionary to hold samples for tissues
tissue_samples = {}

for line in metadata:
    #Removes any extraneous line returns from the right end of lines, splits each line at tabs, and stores the resulting list into the variable "fields"
    fields = line.rstrip("\n").split("\t")
    #Sets up keys and values
    key = fields[6]
    value = fields[0]
    #Safely initializes the dictionary keys
    tissue_samples.setdefault(key,[])
    #Appends values into the empty lists to avoid accidental overwrites
    tissue_samples[key].append(value)

tissue_names = open(sys.argv[3]) #Make sure you load test_data.gct
#Skips the two irrelevant lines
tissue_names.readline()
tissue_names.readline()
#Gets the header and strips out the two columns that aren't names of tissues
header = tissue_names.readline().rstrip("\n").split("\t")
header = header[2:]

#Makes a dictionary to start stitching things together
tissue_columns = {}

#Splits tissue and samples out of tiss_samples
for tissue, samples in tissue_samples.items():
    #Safely sets the tissues as keys of tissue_columns
    tissue_columns.setdefault(tissue, [])
    #Scrolls through the list of samples and confirms where they are in the header
    for sample in samples:
        if sample in header:
            #Stores which column a given sample is in based off of its position in the header
            position = header.index(sample)
            tissue_columns[tissue].append(position)


#Q6 Work
#Initializes a list for storing expression values and gene names
expression_values = []
gene_names = []

for line in tissue_names:
    #Removes any extraneous line returns from the right end of lines, splits each line at tabs, and stores the resulting list into the variable "fields"
    expression_field = line.rstrip("\n").split("\t")
    gene_names.append(expression_field[0])
    #Takes the 2nd and onwards index values of each line and stores them as the expression values for a gene
    expression_values.append(expression_field[2:])

#Converts the expression values into an array
expression_array = numpy.array(expression_values, dtype = float)

#Initialize lists for pulling out values
relevant_gene_row = []
index = 0
relevant_expression_values = {}

#Cycles through every gene name in the data and see if they're present in the relevant genes
for gene_name in gene_names:
    if gene_name in relevant_samples:
        #Appends the relevant rows for genes to index expression values
        relevant_gene_row.append(index)
        #Keys the relevant expression values dictionary with gene, tissue tuples
        key = (gene_name, relevant_samples[gene_name])
        relevant_expression_values.setdefault(key, [])
        #Scans through the expression values list to 
        for gene_row in range(len(expression_array)):
             if gene_row in relevant_gene_row:
                #Pulls the tissue columns relevant for each gene and uses that with the gene rows above to index the needed expression values
                relevant_expression_values[key].append(expression_array[gene_row, tissue_columns[relevant_samples[gene_name]]])
    index += 1

#Q7 Print the dictionary to a tsv
new_file = open("relevant_expression_values",'w')
for key, value in relevant_expression_values.items():
    line = (str(key[0]) + "\t" + str(key[1]) + "\t" + str(value) + "\n")
    new_file.write(line)

gene_tissue.close()
metadata.close()
tissue_names.close()
new_file.close()