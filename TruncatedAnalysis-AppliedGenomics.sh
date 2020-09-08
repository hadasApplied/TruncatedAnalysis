#!/bin/bash

helpFunction()
{
   echo "Usage: $0 -c [] -a [] -r [] -t []"
   echo -e "\t-c Construct name"
   echo -e "\t-a Algae fasta directory"
   echo -e "\t-r R1.fq"
   echo -e "\t-t R2.fq"
   echo ""
   exit 1 # Exit script after printing help
}

runner()
{
  if [ -z $CODE_LOCATION ] ;
  then
    CODE_LOCATION=$(dirname $(readlink -f $0))
    main
  fi
}

main ()
{
  echo ""
  mkdir $con
  echo "made directory" $con
  echo ""
  cp $con.fa $con/
  cd $con
  samtools faidx $con.fa
  bwa index $con.fa
  echo "created bwa index for " $con

  cd ..
  bedtools getfasta -fi $con.fa -bed $con.regions.bed -name > $con.regions.fa
  echo "extracted endogenous regions from " $con
  blastn -db ../../Genomes/$algae/$algae.fna -query $con.regions.fa -out blast.$con.regions.out -outfmt "6 qseqid sseqid sstart send evalue bitscore"
  python parse.raw.blast.py blast.$con.regions.out
  mkdir algae.masked.blast.$con
  bedtools maskfasta -fi ../../Genomes/$algae/$algae.fna -bed $con.blast.algae.bed -fo algae.masked.blast.$con/algae.masked.blast.$con.fa
  samtools faidx algae.masked.blast.$con/algae.masked.blast.$con.fa
  bwa index algae.masked.blast.$con/algae.masked.blast.$con.fa
  echo "created masked fasta for algae"

  bwa mem -T 0 -t 8 -M $con/$con.fa $r1 $r2 > $con.construct-alignment.T0.sam
  samtools view -Sb $con.construct-alignment.T0.sam > $con.construct-alignment.T0.bam
  samtools sort -@8 $con.construct-alignment.T0.bam -o $con.construct-alignment.T0.sorted.bam
  samtools index $con.construct-alignment.T0.sorted.bam
  echo "aligned T=0 for " $con

  bwa mem -T 0 -t 8 -M algae.masked.blast.$con/algae.masked.blast.$con.fa $r1 $r2 > $con.algae-alignment.T0.sam
  samtools view -Sb $con.algae-alignment.T0.sam > $con.algae-alignment.T0.bam
  samtools sort -@8 $con.algae-alignment.T0.bam -o $con.algae-alignment.T0.sorted.bam
  samtools index $con.algae-alignment.T0.sorted.bam
  echo "aligned T=0 for algae"

  java -jar ../jvarkit/dist/samextractclip.jar -c $con.construct-alignment.T0.sam > clipped.fq

  bwa mem -T 0 -t 8 -M $con/$con.fa clipped.fq > clipped.$con.sam
  samtools view -Sb clipped.$con.sam > clipped.$con.bam
  samtools sort -@8 clipped.$con.bam -o clipped.$con.sorted.bam
  samtools index clipped.$con.sorted.bam
  echo "aligned clipped reads for " $con

  bwa mem -T 0 -t 8 -M algae.masked.blast.$con/algae.masked.blast.$con.fa clipped.fq > clipped.algae.sam
  samtools view -Sb clipped.algae.sam > clipped.algae.bam
  samtools sort -@8 clipped.algae.bam -o clipped.algae.sorted.bam
  samtools index clipped.algae.sorted.bam
  echo "aligned clipped reads for algae"

  bedtools genomecov -ibam clipped.algae.sorted.bam -bg | awk '$4>=1' > clipped.algae.sorted.bed
  bedops -m clipped.algae.sorted.bed > clipped.algae.sorted.bg

  echo "running tdnascan"
  cd ../TDNAscan
  python tdnascan.py -1 ../$con/$r1 -2 ../$con/$r2 -g ../$con/algae.masked.blast.$con/algae.masked.blast.$con.fa -t ../$con/$con/$con.fa -p ../$con/tdnascan -b 150
}

while getopts "i:o:t:" opt
do
   case "$opt" in
      c ) con="$OPTARG" ;;
      a ) algae="$OPTARG" ;;
      r ) r1="${OPTARG}" ;;
      t ) r2="${OPTARG}" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$con" ] || [ -z "$algae" ] || [ -z "$r1" ] || [ -z "$r2" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi
