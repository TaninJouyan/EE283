#!/bin/bash 
#SBATCH --job-name=fastqc    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=fastqc_%J.err
#SBATCH --output=fastqc_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00  

forward="P020_R1.fq.gz"
reverse="P020_R2.fq.gz"
input="data/raw/ATACseq/"
output="data/processed/fastqc/"

module load fastqc/0.11.9
module load fastp

#fastqc -t 2 ${input}${forward} ${input}${reverse} > ${output}
fastp -i ${input}${forward} -I ${input}${reverse} -o ${output}"qc_"${forward} -O ${output}"qc_"${reverse}"_pros.fq.gz"
fastqc -t 2 ${output}"qc_"${forward} ${output}"qc_"${reverse}

