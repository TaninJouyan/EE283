#!/bin/bash 
SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/RNAseq/RNAseq384plex_flowcell01"
DestDir="./data/raw/RNAseq"
File="/data/class/ecoevo283/public/Bioinformatics_Course/RNAseq/RNAseq384_SampleCoding.txt"
tail -n +2 ${File} > ./data/raw/RNAseq384_SampleCoding.MOD.txt
input="./data/raw/RNAseq384_SampleCoding.MOD.txt" 
while read p
do
	#echo "${p}"
	Sample=$(echo $p | cut -f1 -d " ")
  	Lane=$(echo $p | cut -f3 -d " ")
  	barcode=$(echo $p | cut -f4 -d " ")
  	fullname=$(echo $p | cut -f12 -d " ")
        RILcode=$(echo $p| cut -f9 -d " ")
        tissue=$(echo $p| cut -f10 -d " ")
       READ1=$(find ${SourceDir}/ -type f -iname "${Sample}_${barcode}_${Lane}_R1_001.fastq.gz")
       READ2=$(find ${SourceDir}/ -type f -iname "${Sample}_${barcode}_${Lane}_R2_001.fastq.gz")
       name1="${RILcode}_${tissue}_R1.fastq.gz"
       name2="${RILcode}_${tissue}_R2.fastq.gz"
       ln -s $READ1 $DestDir/$name1
       ln -s $READ2 $DestDir/$name2

done < $input
