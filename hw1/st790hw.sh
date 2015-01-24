#!/bin/bash
# a 
echo 'Number of persons (n):'
awk 'END { print NR }' /home/st790_003/hw01/merge-geno.fam
echo 'Number of SNPs (p):'
awk 'END { print NR }' /home/st790_003/hw01/merge-geno.bim

# b
echo 'How many SNPs on each chromosome?'
awk '{print $1}' /home/st790_003/hw01/merge-geno.bim | uniq -c

# c
echo 'How many SNPs are on the MAP4 gene?'
awk '$1==3 && $4>=47892180 && $4<=48130769  {print $0}'\
 /home/st790_003/hw01/merge-geno.bim | wc -l

# d.i
echo 'Create Mendel SNP definition file:'
awk 
awk '{ print $2, $1, $4}' /home/st790_003/hw01/merge-geno.bim | head
# d.ii
