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
#The script should be run in file directory

bamCoverage -b A4.sort.bam -o A4.bg --normalizeUsing RPKM -r X:1880000:2000000 -of bedgraph
bamCoverage -b A5.sort.bam -o A5.bg --normalizeUsing RPKM -r X:1880000:2000000 -of bedgraph

bamCoverage -b A4.sort.bam -o A4-e.bg --normalizeUsing RPKM -r X:1880000:2000000 -of bedgraph -e
bamCoverage -b A5.sort.bam -o A5-e.bg --normalizeUsing RPKM -r X:1880000:2000000 -of bedgraph -e



