#!/bin/bash
#SBATCH --job-name=snp
#SBATCH -A class-ecoevo283
#SBATCH -p standard
#SBATCH --cpus-per-task=10
#SBATCH --error=snp_%A.err
#SBATCH --output=snp_%A.out
#SBATCH --mem-per-cpu=3G
#SBATCH --time=1-00:00:00
#SBATCH --array=1-7

ref="/pub/tjouyan/ee283/data/ref/dm6.fasta"

#Split the genome for faster processing

cat $ref | grep ">" | cut -f1 -d" " | tr -d ">" | head -n 7 >chrome.names.txt

#Call SNPs by chromosome

mychr=`head -n $SLURM_ARRAY_TASK_ID chrome.names.txt | tail -n 1`

/opt/apps/gatk/4.1.9.0/gatk --java-options "-Xmx3g" GenotypeGVCFs \
 -R $ref -V allsample.g.vcf.gz --intervals $mychr \
 -stand-call-conf 5 -O result.${mychr}.vcf.gz

#Merge VCFs

java -jar /opt/apps/picard-tools/2.27.1/picard.jar MergeVcfs \
$(printf 'I=%s ' result.*.vcf.gz) O=all_variants.vcf.gz
