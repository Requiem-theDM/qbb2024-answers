#!/usr/bin/env python3

import sys

#This opens the file passed as the first argument of the command to run this script.
my_file = open(sys.argv[1])

#This points at each line of the file sequentially and prints out whatever is written in it.
for line in my_file:
    if "##" in line:
            continue
    fields = line.split("\t")
    if "gene" == fields[2]:
        print (fields)

#If you open something, close it so that you're not opening a million files in the background.
my_file.close()