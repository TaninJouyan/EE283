#!/bin/bash
#SBATCH --job-name=deeptools
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=deep_%J.err
#SBATCH --output=deep_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   

#bamCoverage -b A5_ADL09_1.sort.bam -o A5_ADL09_1.bg --normalizeUsing RPKM
#bamCoverage -b A4_ADL06_1.sort.bam -o A4_ADL06_1.bg --normalizeUsing RPKM

#bamCoverage -b A5_ADL09_1.sort.bam -o A5_ADL09_1.e.bg --normalizeUsing RPKM -e
#bamCoverage -b A4_ADL06_1.sort.bam -o A4_ADL06_1.e.bg --normalizeUsing RPKM -e


plotCoverage -b A4_ADL06_1.sort.bam A5_ADL09_1.sort.bam -o A4_A5.cov.png 
plotCoverage -b A4_ADL06_1.sort.bam A5_ADL09_1.sort.bam -o A4_A5.e.cov.png -e
