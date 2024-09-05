#!/usr/bin/env python3

#Establishes environment
import sys

import numpy

#Opens the file specified by the 1 indexed argument of the command
file = open(sys.argv[1],mode = "r")

#Initializes the lists for storing gene names, ids, and expression values
gene_IDs = []
gene_names = []
expression_values = []

#Skips the two header lines
for i in range(2):
    file.readline()

#Pulls the header line and splits out the name and description columns
header = file.readline().rstrip("\n").split("\t")
tissue_names = header[2:]

#Reads through each line of the file following the header
for line in file:
    #Removes any extraneous line returns from the right end of lines, splits each line at tabs, and stores the resulting list into the variable "fields"
    fields = line.rstrip("\n").split("\t")
    #Takes the 0 and 1 index values of each line's fields and stores them as the gene id and name
    gene_IDs.append(fields[0])
    gene_names.append(fields[1])
    #Takes the 2nd and onwards index values of each line and stores them as the expression values for a gene
    expression_values.append(fields[2:])

#Closes the file as it has served its purpose
file.close()

#Converts the lists to arrays
tissues_array = numpy.array(tissue_names)
id_array = numpy.array(gene_IDs)
name_array = numpy.array(gene_names)
expression_array = numpy.array(expression_values, dtype = float)

#Q4 Mean by numpy of the first 10 expression values
means = numpy.mean(expression_array, axis = 1)[:10]
#print(means) #As expected, most of these are tiny

#Q5 Mean by numpy of the whole dataset
mean = numpy.mean(expression_array)
median = numpy.median(expression_array)
#print(mean, median) #Given the vast difference here, most genes have very low expression across most tissues, but a number of outliers have high enough expression to substantially increase the mean

#Q6 log-transform values
#Adjust values to remove 0s
pc_expression_array = expression_array + 1
#Apply log transformation
pc_expression_array = numpy.log2(pc_expression_array)
#Do math on the transformed array
transformed_mean = numpy.mean(pc_expression_array)
transformed_median = numpy.median(pc_expression_array)
#print(transformed_mean, transformed_median) #The distance between median and mean was substantially compressed. The mean changed by an order of magnitude, while the median only slightly changed.

#Q7 Expression gap
#Sort a copy of the array by tissue type
sorted_expression_array = numpy.sort(pc_expression_array, axis = 1)
diff_array = sorted_expression_array[:,-1] - sorted_expression_array[:,-2]

#Q8
print(name_array[numpy.where(diff_array[:] > 10)])
print(len(name_array[numpy.where(diff_array[:] > 10)]))