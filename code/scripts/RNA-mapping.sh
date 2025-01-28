#!/bin/bash
#SBATCH --job-name=map-rna
#SBATCH -A class-ecoevo283
#SBATCH -p standard
#SBATCH --cpus-per-task=4
#SBATCH --error=map_%J.err
#SBATCH --output=map_%J.out
#SBATCH --mem-per-cpu=3G
#SBATCH --time=1-00:00:00
#SBATCH --array=1-12


input="data/raw/RNAseq/"
output="data/processed/DNAseq/bams/"
ref="data/ref/dm6.fasta"

cd $input
ls *R1.fastq.gz | sed 's/_R1.fastq.gz//' >~/ee283/prefixes-rna.txt
cd ~/ee283

file="prefixes.txt"
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`

hisat2 -p 2 -x dm6_trans -1 ${input}${prefix}"_R1.fastq.gz" -2 ${input}${prefix}"_R2.fastq.gz" |\ 
samtools view -bS - > ${input}${prefix}.bam
samtools sort ${input}${prefix}".bam" -o ${output}${prefix}".sort.bam"
samtools index ${output}${prefix}".sort.bam"
rm ${input}${prefix}".bam"
