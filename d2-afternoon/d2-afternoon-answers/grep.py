#!/usr/bin/env python3

import sys

try:
    term = sys.argv[-2]
except:
    print("Insufficient Argumnents ~ No Specified Search Term or File")
    sys.exit(1)
else:
    if sys.argv[-1] == sys.argv[1]:
            print("Insufficient Argumnents ~ No Specified File")
            sys.exit(1)
    try:
        file = open(sys.argv[-1])
        for line in file:
            line = line.rstrip("\n")
            if sys.argv[1] != "-v":
                if term in line:
                    print(line)
            if sys.argv[1] == "-v":
                if term not in line:
                    print(line)
        file.close()
    except:
        print("File Not Found")
        sys.exit(1)