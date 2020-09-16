# TruncatedAnalysis
Program to analyze insertion locations of construct in foregin genome

## Required Programs
* samtools 1.9
* bedtools v2.29.2
* Python 2.7
    * numpy==1.16.5
    * pandas==0.24.2
* BLAST 2.9.0+
* bedops 2.4.37
* BWA 0.7.12
* picard FilterSamReads 2.22.9


## Endogenous regions by construct
| construct        | FCPA/LHCF4/CLP promoter | UTR       | Vac       | FCPA-terminator | FCPB/LHCF4 promoter | UTR       | FCPA-terminator |
|------------------|-------------------------|-----------|-----------|-----------------|---------------------|-----------|-----------------|
| 523              | 902-1342                |           | 1347-1412 | 2175-2504       | 2505-2749           |           | 3125-3366       |
| 527              | 902-1342                |           | 1347-1412 | 2145-2474       | 2475-2719           |           | 3095-3336       |
| 663              | 902-1342                |           | 1386-1451 | 2034-2363       | 2364-2608           |           | 2984-3225       |
| 685              | 899-1898                | 1899-1928 | 1929-1994 | 2577-2906       | 2907-3151           |           | 3527-3768       |
| 707 all colonies | 899-1400                |           | 1463-1528 | 2261-2590       | 2591-2835           |           | 3211-3452       |
| 730              | 899-1898                | 1899-1915 | 1937-2002 | 2441-2770       | 2771-3015           |           | 3391-3632       |
| 833              | 1211-2210               | 2211-2240 | 2242-2307 | 2882-3211       | 3224-4223           | 4224-4253 | 5738-5979       |
