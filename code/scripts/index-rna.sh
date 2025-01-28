#!/bin/bash 
#SBATCH --job-name=index   
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=8  
#SBATCH --error=align_%J.err
#SBATCH --output=align_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   

ln -s /data/class/ecoevo283/public/Bioinformatics_Course/ref/
dmel-all-r6.13.gtf data/ref/dm6.gtf

module load hisat2/2.2.1
ref="data/ref/dm6.fasta"
gtf="data/ref/dm6.gtf"
python hisat2_extract_splice_sites.py $gtf > dm6.ss
python hisat2_extract_exons.py $gtf > dm6.exon
hisat2-build -p 8 --exon dm6.exon --ss dm6.ss $ref dm6_trans
