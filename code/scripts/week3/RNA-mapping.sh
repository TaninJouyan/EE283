#!/bin/bash
#SBATCH --job-name=map-rna
#SBATCH -A class-ecoevo283
#SBATCH -p standard
#SBATCH --cpus-per-task=10
#SBATCH --error=map-rna_%A.err
#SBATCH --output=map_%A.out
#SBATCH --mem-per-cpu=3G
#SBATCH --time=1-00:00:00
#SBATCH --array=1-20


input="data/raw/RNAseq"
output="data/processed/RNAseq/bams"
ref="data/ref/RNA-hisat"

#cd ${input}/
#ls *R1.fastq.gz | awk '/21148|21286|22162|21297|21029|22052|22031|21293|22378|22390/ && /_[BE]_/' | sed 's/_R1.fastq.gz//' > /pub/tjouyan/ee283/prefixes-rna.txt
#cd /pub/tjouyan/ee283/

file="prefixes-rna.txt"
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`

module load hisat2/2.2.1
module load samtools/1.15.1

hisat2 -x $ref/dm6_trans -1 $input/${prefix}_R1.fastq.gz -2 $input/${prefix}_R2.fastq.gz >  ${output}/${prefix}.sam 
samtools view -bS ${output}/${prefix}.sam > ${output}/${prefix}.bam
samtools sort ${output}/${prefix}.bam -o ${output}/${prefix}.sort.bam
samtools index ${output}/${prefix}.sort.bam
