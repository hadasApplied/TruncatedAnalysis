#!/bin/bash

args=("$@")
echo "coord->"  ${args[0]}
echo "informative genome->" ${args[1]}
echo "TDNA_sort->" ${args[2]}

samtools view -b ${args[1]} ${args[0]} > ${args[0]}.bam
samtools view ${args[0]}.bam | awk '{print $1}' > ${args[0]}.readID.txt
picard FilterSamReads I=${args[2]} O=${args[0]}.construct.bam READ_LIST_FILE=${args[0]}.readID.txt FILTER=includeReadList
samtools index ${args[0]}.construct.bam
