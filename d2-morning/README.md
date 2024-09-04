# Day2 - Lunch Answers

## Answer 1

- `cut -f 7 hg38-gene-metadata-feature.tsv | grep -v "gene_biotype" | sort | uniq -c | sort -n -r`
- There are 19618 protein coding genes.
- I am most interested in lncRNA samples due to my prior experience working in a lncRNA lab.

## Answer 2

- `grep -v "ensembl_gene_id" hg38-gene-metadata-go.tsv | cut -f 1 | sort | uniq -c | sort -n`
- ENSG00000168036 with 273 counts has the most go_ids.
- `grep -w "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -k 3 -f > ENSG00000168036.txt`
- Given the presence of signaling pathway and cell junction GO terms, I suspect the gene is likely involved in cell surface signalling pathways.

## Answer 3

- `grep -w "IG\_.*\_gene" genes.gtf | grep -v "pseudogene"  | cut -f 1 | sort | uniq -c | sort -n -r`
-  91 chr14
-  52 chr2
-  48 chr22
-  16 chr15
-   6 chr16
-   1 chr21
-  `rep -w "IG\_.*\_gene" genes.gtf | grep  "pseudogene"  | cut -f 1 | sort | uniq -c | sort -n -r `
-  84 chr14
-  48 chr22
-  45 chr2
-   8 chr16
-   6 chr15
-   5 chr9
-   1 chr8
-   1 chr18
-   1 chr10
-   1 chr1

## Answer 4

- This grep would return any line where pseudogene occurs in any context, regardless of if that is as a "processed_pseudogene", "unprocessed_pseudogene", "transcribed_unprocessed_pseudogene", or simply a gene that "overlaps_pseudogene".

## Answer 5

- `cut -f 1,4,5,10 gene-tabs.gtf > gene-tabs.bed`
