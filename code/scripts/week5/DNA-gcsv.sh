#!/bin/bash 
#SBATCH --job-name=gcsv-dna
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=8
#SBATCH --error=gcsv-dna_%A.err
#SBATCH --output=gcsv-dna_%A.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00  
##SBATCH --array=1-4

#ls *1.sort.bam | awk -F'_' '{print $1}'|sort | uniq > prefix-dna.txt 
file="prefix-dna.txt" 
prefix=`head -n $SLURM_ARRAY_TASK_ID $file | tail -n 1`
ref='/pub/tjouyan/ee283/data/ref/dm6.fasta' 

module load java/1.8.0 
module load gatk/4.2.6.1 
module load picard-tools/2.27.1 
module load samtools/1.15.1

#samtools merge -o ${prefix}.bam ${prefix}_1.sort.bam ${prefix}_2.sort.bam ${prefix}_3.sort.bam
#samtools sort ${prefix}.bam -o ${prefix}.sort.bam
#java -jar /opt/apps/picard-tools/2.27.1/picard.jar AddOrReplaceReadGroups I=${prefix}.sort.bam O=${prefix}.RG.bam SORT_ORDER=coordinate \
#RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=${prefix} RGSM=${prefix} \
#VALIDATION_STRINGENCY=LENIENT
#java -jar /opt/apps/picard-tools/2.27.1/picard.jar MarkDuplicates REMOVE_DUPLICATES=true \
#I=${prefix}.RG.bam O=${prefix}.dedup.bam M=${prefix}_marked_dup_metrics.txt
#samtools index ${prefix}.dedup.bam
#/opt/apps/gatk/4.2.6.1/gatk HaplotypeCaller -R $ref -I ${prefix}.dedup.bam \
# --minimum-mapping-quality 30 -ERC GVCF -O ${prefix}.g.vcf.gz
/opt/apps/gatk/4.2.6.1/gatk CombineGVCFs -R $ref $(printf -- '-V %s ' *.g.vcf.gz) -O allsample.g.vcf.gz
