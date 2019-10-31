#!/bin/bash

module load meme
# this is for motif scanning

indir="/bi/scratch/Stephen_Clark/gastrulation_data/features/fasta/prom"
#indir="/bi/scratch/Stephen_Clark/gastrulation_data/features/sjc/significant_sites/fasta"
#background="/bi/scratch/Stephen_Clark/gastrulation_data/features/ChIP/fasta/background/H3K27ac_distal_E7_5_union.fa"
outdir="/bi/scratch/Stephen_Clark/gastrulation_data/features/fimo/prom_2000_2000/new"
pwm="/bi/scratch/Stephen_Clark/gastrulation_data/features/sjc/PWM/JASPAR2018_CORE_vertebrates_non-redundant_pfms_meme.txt"

mkdir -p $outdir

cd $indir

for file in *.fa
do
#back="$background"
out="$outdir/$file"
echo -e $file
#echo -e $back
#fimo --text --oc  $out $pwm $file 
fimo --oc  $out $pwm $file 
done