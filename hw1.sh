#!/bin/bash
#SBATCH --job-name=w1HW
#SBATCH -A ecoevo283 
#SBATCH --partition=standard 
#SBATCH --cpus-per-task=1 


wget https://wfitch.bio.uci.edu/~tdlong/problem1.tar.gz
tar -xvf problem1.tar.gz

head -n 10 problem1/{p,f}.txt | tail -1
