#!/bin/bash
#SBATCH -A class-ecoevo283
#SBATCH --job-name=extract
#SBATCH --cpus-per-task=1
#SBATCH --error=extract_%A.err
#SBATCH --output=extract_%A.out
#SBATCH --mem-per-cpu=3G
#SBATCH --time=1-00:00:00

input='data/processed/DNAseq/bams'

module load samtools/1.15.1


samtools view -b $input/ADL06_1.sort.bam -q 30 X:1880000-2000000 -o $input/A4.bam
samtools sort $input/A4.bam -o $input/A4.sort.bam
samtools index $input/A4.sort.bam
samtools view -b $input/ADL09_1.sort.bam -q 30 X:1880000-2000000 -o $input/A5.bam
samtools sort $input/A5.bam -o $input/A5.sort.bam
samtools index $input/A5.sort.bam
