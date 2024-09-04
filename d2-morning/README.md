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