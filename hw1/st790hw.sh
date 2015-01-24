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
awk '$1==3 && $4>=47892180 && $4<=48130769  {print $0}' /home/st790_003/hw01/merge-geno.bim | wc -l

# d.i
echo 'Create Mendel SNP definition file in mendel_snp.txt' 
echo '2.40 = FILE FORMAT VERSION NUMBER.' > mendel_snp.txt
printf " `awk 'END {print NR}' /home/st790_003/hw01/merge-geno.bim` `echo ' = NUMBER OF SNPS LISTED HERE.'` \n" >>  mendel_snp.txt
awk '{ print $2, $1, $4}' /home/st790_003/hw01/merge-geno.bim | head >>  mendel_snp.txt
echo 'head mendel_snp.txt'
head mendel_snp.txt

# d.ii
echo 'Create Mendel pedigree file in mendel_ped.txt'
awk '{ print $1, $2, $3, $4, $5 }' /home/st790_003/hw01/merge-geno.fam > mendel_ped1.txt
awk '{ gsub(1,"M",$5); print $0} ' mendel_ped1.txt > mendel_ped2.txt 
awk '{ gsub(2,"F",$5); print $0} ' mendel_ped2.txt > mendel_ped3.txt
awk '{ OFS=","} { print $1, substr($2,5),substr($3,5), substr($4,5), $5, ""}' mendel_ped3.txt >mendel_ped.txt
rm mendel_ped1.txt mendel_ped2.txt mendel_ped3.txt 
echo 'head mendel_ped.txt'
head mendel_ped.txt