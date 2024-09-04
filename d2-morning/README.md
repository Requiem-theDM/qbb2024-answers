# Day2 - Lunch Answers

## Answer 1

- `cut -f 7 hg38-gene-metadata-feature.tsv | grep -v "gene_biotype" | sort | uniq -c | sort -n -r`
- There are 19618 protein coding genes.
- I am most interested in lncRNA samples due to my prior experience working in a lncRNA lab.