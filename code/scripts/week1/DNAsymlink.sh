#!/bin/bash


SourceDir="/data/class/ecoevo283/public/Bioinformatics_Course/DNAseq"
DestDir="data/raw/DNAseq"
FILES="$SourceDir/*"
for f in $FILES
do
   ff=$(basename $f)
   echo "Processing $ff file..."
   echo $SourceDir/$ff
   echo $DestDir/$ff
   ln -s $SourceDir/$ff $DestDir/$ff
done
