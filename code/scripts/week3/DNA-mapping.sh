#!/bin/bash 
#SBATCH --job-name=map    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   
#SBATCH --output=logs/map-dna_%A.out
#SBATCH --error=logs/map-dna_%A.err
#SBATCH --array=1-12

input="data/raw/DNAseq"
qoutput="data/processed/DNAseq/bams"
ref="data/ref"

#cd $input
#ls *1.fq.gz | sed 's/_1.fq.gz//' >~/ee283/prefixes.txt
#cd ~/ee283

file="prefixes.txt"
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`

module load bwa/0.7.8
module load samtools/1.15.1

bwa mem -t 2 -M $ref/dm6.fasta ${input}/${prefix}_1.fq.gz ${input}/${prefix}_2.fq.gz \
| samtools view -bS - > ${output}/${prefix}.bam
samtools sort ${output}/${prefix}.bam -o ${output}/${prefix}.sort.bam 
samtools index ${output}/${prefix}.sort.bam


