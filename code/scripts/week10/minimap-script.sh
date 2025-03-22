#!/bin/bash 
#SBATCH --job-name=minimap    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=1  
#SBATCH --error=minimap_%J.err
#SBATCH --output=minimap_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00 

sample1="data/raw/casr2.m6a"
sample2="data/raw/bam/b6r2.m6a"
sample3="data/raw/casr2.m5c"
sample4="data/raw/bam/b6r2.m5c"

gtf="/share/crsp/lab/seyedam/share/bridge_dRNA/gtfref/gencode.vM32.chr_patch_hapl_scaff.annotation.gtf"
ref="/share/crsp/lab/seyedam/share/c2c12_dRNA/refgenome/mm39.fa"

output="/data/processed/bams"

module load samtools
module load minimap2

samtools fastq --threads 64 -T MM,ML ${sample1}"_unmapped.bam" \
| minimap2 -t 64 -ax splice --junc-bed ${gtf} --secondary=no --MD -y ${ref} - \
| samtools sort - --threads 64 > ${output}${sample1}".bam" \
&& samtools index -@ 64 ${output}${sample1}".bam"

samtools fastq --threads 64 -T MM,ML ${sample2}"_unmapped.bam" \
| minimap2 -t 64 -ax splice --junc-bed ${gtf} --secondary=no --MD -y ${ref} - \
| samtools sort - --threads 64 > ${output}${sample2}".bam" \
&& samtools index -@ 64 ${output}${sample2}".bam"

samtools fastq --threads 64 -T MM,ML ${sample3}"_unmapped.bam" \
| minimap2 -t 64 -ax splice --junc-bed ${gtf} --secondary=no --MD -y ${ref} - \
| samtools sort - --threads 64 > ${output}${sample3}".bam" \
&& samtools index -@ 64 ${output}${sample3}".bam"

samtools fastq --threads 64 -T MM,ML ${sample4}"_unmapped.bam" \
| minimap2 -t 64 -ax splice --junc-bed ${gtf} --secondary=no --MD -y ${ref} - \
| samtools sort - --threads 64 > ${output}${sample4}".bam" \
&& samtools index -@ 64 ${output}${sample4}".bam"

