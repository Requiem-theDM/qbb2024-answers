#!/usr/bin/env python3

import sys

#This opens the file passed as the second argument of the command to run this script.
file = open(sys.argv[2])
#This takes the search term from the first argument of the command to run this script.
columns = sys.argv[1].split(",")

for line in file:
    #This outer loop goes line by line in the file, strips line returns, and splits at tabs.
    line = line.rstrip("\n")
    fields = line.split("\t")
    found = ""
    for column in columns:
        #This inner loop goes column by column in each line and uses string concatenation to append the appropriate field to the found string.
        found = found + "\t" + str(fields[int(column)])
    #This prints the found string as a single line
    print(found)

file.close()