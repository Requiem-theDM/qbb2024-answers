#!/bin/bash

for FEATURE in exons genes cCREs #Loops through the three features and sorts them, then merges duplicates
do
    bedtools sort ${FEATURE}_raw.bed > ${FEATURE}_sorted.bed
    bedtools merge ${FEATURE}_sorted.bed > ${FEATURE}_chr1.bed
done

bedtools subtract -a genes_chr1.bed -b exons_chr1.bed > introns_chr1.bed #Subtracts exonds from genes to make introns
bedtools subtract -a genome_chr1.bed -b exons_chr1.bed introns_chr1.bed cCREs_chr1.bed > other_chr1.bed #Subtracts our other genome features to get the remainder