#!/bin/bash
#SBATCH -A CLASS-ECOEVO283
#SBATCH --job-name=w1HW
#SBATCH --partition=standard 
#SBATCH --cpus-per-task=1 


wget https://wfitch.bio.uci.edu/~tdlong/problem1.tar.gz
tar -xvf problem1.tar.gz

head -n 10 problem1/p.txt | tail -1
head -n 10 problem1/f.txt | tail -1
