#!/bin/bash 
 

SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/ATACseq"
DestDir="data/raw/ATACseq"
READme="/data/class/ecoevo283/public/Bioinformatics_Course/ATACseq/README.ATACseq.txt"
File="ATACseq.labels.txt"

tail -n +2 ${READme} |head -n -4  > ${File}
while read p
do
   echo "${p}"
   barcode=$(echo $p | cut -f1 -d" ")
   genotype=$(echo $p | cut -f2 -d" ")
   tissue=$(echo $p | cut -f3 -d" ")
   bioRep=$(echo $p | cut -f4 -d" ")
   READ1=$(find ${SourceDir}/ -type f -iname "*_${barcode}_R1.fq.gz")
   READ2=$(find ${SourceDir}/ -type f -iname "*_${barcode}_R2.fq.gz")

   ff1=$(basename $READ1)
   ff2=$(basename $READ2)

   ln -s $READ1 $DestDir/$ff1 # now make the symlink
   ln -s $READ2 $DestDir/$ff2 

done < $File

