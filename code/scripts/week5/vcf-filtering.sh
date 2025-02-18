#!/bin/bash 
#SBATCH --job-name=filter    
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=10  
#SBATCH --error=filter_%J.err
#SBATCH --output=filter_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00 


module load  bcftools/1.15.1

#retain high confident by removing 1) seq artifact 2) repitative and misaligned variants 3)poor quality metrics variants 

bcftools filter -i 'FS<40.0 && SOR<3 && MQ>40.0 && MQRankSum>-5.0 && MQRankSum<5 && QD>2.0 && ReadPosRankSum>-4.0 && INFO/DP<16000' -O z -o filter1.vcf.gz all_variants.vcf.gz

#In this step well-supported variants/read depth (reads > 3) and gene quality (quality score of >20) is kept the rest is filtered.

bcftools filter -S . -e 'FMT/DP<3 | FMT/GQ<20' -O z -o filter2.vcf.gz filter1.vcf.gz

# removing variants with no alternative allele || and variants with all alleles being alternative one 

bcftools filter -e 'AC==0 || AC==AN' --SnpGap 10 filter2.vcf.gz | \
bcftools view -m2 -M2 -v snps -O z -o filter3.vcf.gz
