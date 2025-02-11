#!/bin/bash 
#SBATCH --job-name=map-atac    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=10
#SBATCH --error=map-atac_%A.err
#SBATCH --output=map-atac_%A.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00   
#SBATCH --array=1-12

input="data/raw/ATACseq"
output="data/processed/ATACseq/bams"
ref="data/ref"

cd ${input}/
ls *R1.fq.gz | sed 's/_R1.fq.gz//' >/pub/tjouyan/ee283/prefixes-atac.txt
cd /pub/tjouyan/ee283

file="prefixes-atac.txt"
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`

module load samtools/1.15.1
module load bwa/0.7.8

bwa mem -t 2 -M $ref/dm6.fasta ${input}/${prefix}_R1.fq.gz ${input}/${prefix}_R2.fq.gz \
| samtools view -bS - > $output/${prefix}.bam
samtools sort ${output}/${prefix}.bam -o ${output}/${prefix}.sort.bam
#rm ${output}/${prefix}.bam
