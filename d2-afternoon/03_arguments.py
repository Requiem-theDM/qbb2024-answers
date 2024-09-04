#!/usr/bin/env python3

import sys

#Lists store a sequence of values, when you print a range, the first value is included and the last value is excluded
print(sys.argv)
print(sys.argv[1:3])
num_arg = len(sys.argv)

#Can only concatenate strings to strings with + operand, so you have to convert integers into a string with str()
print("Number of arguments: " + str(num_arg))

i = 0
for my_arg in sys.argv:
    print( str(i) + "th argument is " + sys.argv[i])
    i = i + 1

