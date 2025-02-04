#!/bin/bash 
#SBATCH --job-name=align    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=align_%J.err
#SBATCH --output=align_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   

#ln -s /data/class/ecoevo283/public/Bioinformatics_Course/ref/dmel-all-chromosome-r6.13.fasta data/ref/dm6.fasta

ref="data/ref/dm6.fasta"

module load picard-tools/2.27.1
module load samtools/1.15.1
module load bwa/0.7.8
module laod java

bwa index $ref
samtools faidx $ref 

java -jar /opt/apps/picard-tools/2.27.1/picard.jar CreateSequenceDictionary R=$ref O=data/ref/dm6.dict
