#!/bin/bash 
#SBATCH --job-name=fastp    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=fastp_%J.err
#SBATCH --output=fastp_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   

forward="ADL06_1_1"
reverse="ADL06_1_2"
input="data/raw/DNAseq/"
output="data/processed/"

module load fastp

fastp -i ${input}${forward}".fq.gz" -I ${input}${reverse}".fq.gz" -o ${output}${forward}"_pros.fq.gz" -O ${output}${reverse}"_pros.fq.gz"
