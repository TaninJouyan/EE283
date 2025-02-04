#!/bin/bash 
#SBATCH --job-name=trim    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=trim_%J.err
#SBATCH --output=trim_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00  

forward="data/raw/DNAseq/ADL06_1_1.fq.gz"
reverse="data/raw/DNAseq/ADL06_1_2.fq.gz"

#module load fastqc/0.11.9
module load java/1.8.0  
module load trimmomatic/0.39

java -jar /opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar --help

#fastqc -t 2 ${forward} ${reverse} 

java -jar /opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar PE ${forward} ${reverse}  ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 MINLEN:36 /

