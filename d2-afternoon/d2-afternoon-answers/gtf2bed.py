#!/usr/bin/env python3

import sys

file = open(sys.argv[1])

new_file = open("gencode.v46.basic.annotation.bed",'w')

for line in file:
    if "##" in line:
        continue
    line = line.rstrip("\".")
    line = line.rstrip("\n")
    fields = line.split("\t")
    if fields[2] == "gene":
        nested_fields = fields[8].split(" ")
        found = ""
        previous_gene = ""
        i = 0
        for argument in nested_fields:
                i += 1
                if "gene_name" in argument:
                    found = found + str(fields[0]) + "\t" + str(fields[3]) + "\t" + str(fields[4]) + "\t" + str(nested_fields[i].lstrip("\"").rstrip("\";"))
                    print(found)
                else:
                    continue
    else:
        continue
        
            

file.close()