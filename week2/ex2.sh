#!/bin/bash

echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt
for MAF in 0.1 0.2 0.3 0.4 0.5 #Loops through every MAF level
do
    MAFFILE=chr1_snps_${MAF}.bed #Picks the correct file based on MAF level
    bedtools coverage -a genome_chr1.bed -b ${MAFFILE} > background${MAF}.txt #Checks the coverage of SNPs for a given MAF level and stores it to background${MAF}.txt
    GENOMESNP=$(awk '{s+=$4}END{print s}' background${MAF}.txt) #Pulls the number of SNPs found in the genome
    GENOMEBASE=$(awk '{s+=$6}END{print s}' background${MAF}.txt) #Pulls the number of bases found in the genome
    BACKGROUNDDENSITY=$(bc -l -e "${GENOMESNP} / ${GENOMEBASE}") #Calculates the background density of SNPs in the genome
    for FEATURE in exons introns cCREs other #Loops through every feature type
    do
        FEATUREFILE=${FEATURE}_chr1.bed #Picks the correct file based on feature type
        bedtools coverage -a ${FEATUREFILE} -b ${MAFFILE} > coverage_${MAF}_${FEATURE}.txt #Checks the coverage of SNPs on a given feature and stores it to coverage_${MAF}_${FEATURE}.txt
        FEATURESNP=$(awk '{s+=$4}END{print s}' coverage_${MAF}_${FEATURE}.txt) #Pulls the number of SNPs found in a feature
        FEATUREBASE=$(awk '{s+=$6}END{print s}' coverage_${MAF}_${FEATURE}.txt) #Pulls the number of bases found in a feature
        FEATUREDENSITY=$(bc -l -e "${FEATURESNP} / ${FEATUREBASE}") #Calculates the density of SNPs in a feature
        ENRICHMENT=$(bc -l -e "${FEATUREDENSITY} / ${BACKGROUNDDENSITY}") #Calculates the enrichment of feature SNPs relative to background
        echo -e "${MAF}\t${FEATURE}\t${ENRICHMENT}" >> snp_counts.txt #Appends the calculated result to the results file.
    done
done