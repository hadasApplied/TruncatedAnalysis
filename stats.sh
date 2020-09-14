#!/bin/bash

args=("$@")
echo "algae alignment->"  ${args[0]}
echo "IR1 bam->" ${args[1]}
echo "IR2 bam->" ${args[2]}

echo "Total reads"
samtools view -c ${args[0]}
echo "Mapped to algae"
samtools view -c -F 260 ${args[0]}
echo "Unmapped to algae"
samtools view -c -f 260 ${args[0]}

echo "Mapped to construct"
samtools view -c -F 260 ${args[1]}
echo "Unmapped to construct"
samtools view -c -f 260 ${args[1]}

echo "IR2"
samtools view -c -F 260 ${args[2]}
echo "Unmapped IR2"
samtools view -c -f 260 ${args[2]}
