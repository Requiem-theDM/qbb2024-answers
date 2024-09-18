## Exercise 1.1
- 30,000 reads are needed to reach 3x coverage.

## Exercise 1.2
- `./exercises.py 3 > ex1_2_output.txt`

## Exercise 1.4
- 51,689 sites had 0 coverage depth.
- `grep -v 10 ex1_2_output.txt | grep 0 | wc -l`
- Both normal and poisson distributions match the data relatively well, with the poisson distribution matching slightly better due to the low coverage.

## Exercise 1.5
-  72 sites had 0 coverage depth.
- `grep -v 10 ex1_5_output.txt | grep -v 20 | grep -v 30 | grep 0 | wc -l`
- Both normal and poisson distributions match the data relatively well, with the normal distribution matching slightly better due to the increased coverage.

## Exercise 1.6
-  5 sites had 0 coverage depth.
- `grep -v 10 ex1_6_output.txt | grep -v 20 | grep -v 30 | grep -v 40 | grep -v 50 | grep -v 60 | grep -v 70 | grep -v 80 | grep -v 90 | grep -v 100 | grep 0 | wc -l`
- Both normal and poisson distributions match the data extremely well, with the normal distribution matching slightly better due to the high coverage.

## Exercise 2.4
- `dot -Tpng ex2_1.dot > ex2_digraph.png`

## Exercise 2.5
- ATTCATTCTTATTGATTT

## Exercise 2.6
- We would need to compare all of our possible assemblies generated from the short-read sequencing data with longer reads from the same original sequence in order to accurately determine how best to reconstruct the full genome.