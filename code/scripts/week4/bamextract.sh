#!/bin/bash
#SBATCH -A class-ecoevo283
#SBATCH --job-name=extract
#SBATCH --cpus-per-task=1
#SBATCH --error=extract_%A.err
#SBATCH --output=extract_%A.out
#SBATCH --mem-per-cpu=3G
#SBATCH --time=1-00:00:00


module load samtools/1.15.1


samtools view -b ADL06_1.sort.bam -q 30 X:1880000-2000000 > A4.bam
samtools sort A4.bam -o A4.sort.bam
samtools index A4.sort.bam
samtools view -b ADL09_1.sort.bam -q 30 X:1880000-2000000 > A5.bam
samtools sort A5.bam -o A5.sort.bam
samtools index A5.sort.bam
