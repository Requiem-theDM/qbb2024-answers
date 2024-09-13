#!/usr/bin/env python3

import sys
import numpy

numpy.random.seed(42) #Sets 42 as the random seed to ensure consistency

genomeSize = 1000000
desiredCoverage = int(sys.argv[1])
readSize = 100

numberReads = int(genomeSize * desiredCoverage / readSize) #Minimum number of reads to reach desired coverage of a 1,000,000 bp region with 100 bp reads
genomeCoverage = numpy.zeros(1000000, int) #Generate an array of coverage counts

for readCount in range(numberReads): #Repeats 30000 times to give the minimum number of reads.
    startPosition = numpy.random.randint(0,len(genomeCoverage) - 99) #Sets the start position of a read at a random point where a full read can be made
    endPosition = startPosition + 100 #Sets the end position of a read 100 bp after the start position
    genomeCoverage[startPosition:endPosition] += 1 #Increments the coverage count of each bp covered by a given read

for bp in genomeCoverage: #Prints the genome coverage for piping to a files
    print(bp)