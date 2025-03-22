#!/bin/bash 
#SBATCH --job-name=modkit    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=modkit_%J.err
#SBATCH --output=modkit_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00 

sample1="data/processed/bams/casr2.m6a"
sample2="data/processed/bams/b6r2.m6a"
sample3="data/processed/bams/casr2.m5c"
sample4="data/processed/bams/b6r2.m5c"
output="/data/processed/bedMethyl/"

modkit pileup -t 12 --filter-threshold 0.9 ${sample1}".bam" ${output} ${sample1} ".filtered-4-5.bed"
modkit pileup -t 12 --filter-threshold 0.9 ${sample2}".bam" ${output} ${sample2} ".filtered-4-5.bed"
modkit pileup -t 12 --filter-threshold 0.9 ${sample3}".bam" ${output} ${sample3} ".filtered-4-5.bed"
modkit pileup -t 12 --filter-threshold 0.9 ${sample4}".bam" ${output} ${sample4} ".filtered-4-5.bed"
