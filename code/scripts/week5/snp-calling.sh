# The follwoing commands were ran on an interactive node

module load vcftools

#Creating biallelic SNPs from the first 1Mb of  ChrX
vcftools --gzvcf filter3.vcf.gz --012 --chr X --from-bp 1 --to-bp 1000000

#Getting the numer of snps between each filtering step
zgrep -vc '^#' filter1.vcf.gz
zgrep -vc '^#' filter2.vcf.gz 
zgrep -vc '^#' filter3.vcf.gz 
zgrep -vc '^#' all_variants.vcf.gz

#Extract snp with 50% frequency

awk '{sum=$(NF-3)+$(NF-2)+$(NF-1)+$NF; if($(NF-3)!=1 && $(NF-2)!=1 && $(NF-1)!=1 && $NF!=1 && sum==4) print $0}' out.012 > filtered-isogenic.out.012
