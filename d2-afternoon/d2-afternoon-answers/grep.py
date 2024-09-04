#!/usr/bin/env python3

import sys

#This opens the file passed as the second argument of the command to run this script.
file = open(sys.argv[2])
#This takes the search term from the first argument of the command to run this script.
term = sys.argv[1]

for line in file:
    line = line.rstrip("\n")
    if term in line:
        print(line)


file.close()