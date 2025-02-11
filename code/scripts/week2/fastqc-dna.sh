#!/bin/bash 
#SBATCH --job-name=fastqc    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=fastqc_%J.err
#SBATCH --output=fastqc_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   

forward="ADL06_1_1"
reverse="ADL06_1_2"
input="data/raw/DNAseq/"
output="data/processed/fastqc/"
module load fastqc/0.11.9
module load fastp

fastqc -t 2 ${input}${forward}".fq.gz" ${input}${reverse}".fq.gz"

fastp -i ${input}${forward}".fq.gz" -I ${input}${reverse}".fq.gz" -o ${output}${forward}"_pros.fq.gz" -O ${output}${reverse}"_pros.fq.gz" 

fastqc -t ${output}${forward}"_pros.fq.gz" ${output}${reverse}"_pros.fq.gz"

