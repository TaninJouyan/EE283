#!/bin/bash 
#SBATCH --job-name=readcount   
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=6  
#SBATCH --error=readcount_%J.err
#SBATCH --output=readcount_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00 


module load subread/2.0.3

# The gtf should match the genome you aligned to coordinates and chromosome names
gtf="/pub/tjouyan/ee283/data/ref/dm6.ncbiRefSeq.gtf"
# The program expects a space delimited set of files...

myfile=`cat shortRNAseq.txt | tr "\n" " "`
featureCounts -p -T 8 -t exon -g gene_id -Q 30 -F GTF -a $gtf -o fly_counts.txt $myfile





