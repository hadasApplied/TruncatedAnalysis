import os
import sys
import pysam

inbam = pysam.AlignmentFile("custom3.only.bam", "rb")

outbam = pysam.AlignmentFile("custom3.only.NoHard.bam", 'wb', template=inbam)
for read in inbam.fetch(until_eof=True):
    if 'H' not in read.cigarstring:
        outbam.write(read)
outbam.close()
