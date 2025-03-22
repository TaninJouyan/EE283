#!/bin/bash 
#SBATCH --job-name=dorado   
#SBATCH -A class-ecoevo283    
#SBATCH -p standard       
#SBATCH --cpus-per-task=8  
#SBATCH --error=dorado_%J.err
#SBATCH --output=dorado_%J.out
#SBATCH --mem-per-cpu=3G    
#SBATCH --time=1-00:00:00

inputdir="/data/raw/pod5s/"
outputdir="/data/raw/bams/"

#still need fixing
module load python/3.10.2

cd ${inputdir}
#for arg in pod5/*.pod5
for arg in igvfr_772-22_drna_p2_1/pod50/*.pod5
do
fullfile=$(basename $arg)
file=${fullfile%.*}

~/dorado-0.8.1-linux-x64/bin/dorado basecaller sup,m6a --models-directory ~/dor8mod $arg > ${outputdir}/$file.bam

~/dorado-0.8.1-linux-x64/bin/dorado basecaller sup,m5C --models-directory ~/dor8mod $arg > ${outputdir}/$file.bam
done
