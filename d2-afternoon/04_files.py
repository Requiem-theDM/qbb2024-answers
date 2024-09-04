#!/usr/bin/env python3

import sys

#This opens the file passed as the first argument of the command to run this script.
my_file = open(sys.argv[1])

#This points at each line of the file sequentially and prints out whatever is written in it.
i = 0
for line in my_file:
    #This removes the extra new line character from the right side of the string.
    line = line.rstrip("\n")
    i = i +1
    print(str(i) + " " + str(line))
   
#This prints the final number of lines.
print("Final Line Count: " + str(i))

#If you open something, close it so that you're not opening a million files in the background.
my_file.close()