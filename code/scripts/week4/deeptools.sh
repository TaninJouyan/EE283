#!/bin/bash
#SBATCH --job-name=deeptools
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=deep_%J.err
#SBATCH --output=deep_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   

# Deeptools environment should be activated 
#the script is ran in fle directory

bamCoverage -b A5.sort.bam -o A5.bw --normalizeUsing RPKM
bamCoverage -b A4.sort.bam -o A4.bw --normalizeUsing RPKM

bamCoverage -b A5.sort.bam -o A5.bg --normalizeUsing RPKM -of bedgraph
bamCoverage -b A4.sort.bam -o A4.bg --normalizeUsing RPKM -of bedgraph
#bamCoverage -b A5.sort.bam -o A5.e.bg --normalizeUsing RPKM -e
#bamCoverage -b A4.sort.bam -o A4.e.bg --normalizeUsing RPKM -e

bamCoverage -b A5.sort.bam -o A5.bg --normalizeUsing RPKM -of bedgraph -e
bamCoverage -b A4.sort.bam -o A4.bg --normalizeUsing RPKM -of bedgraph -e

#plotCoverage -b A4.sort.bam A5.sort.bam -o A4_A5.cov.png 
#plotCoverage -b A4.sort.bam A5.sort.bam -o A4_A5.e.cov.png -e
