# rm_dup
remove the PCR duplication from PE150 fastq reads.

perl find_dup.pl -fq1 raw_fq1 -fq2 raw_fq2 -out dup.list
perl rm_dup.pl -fq1 raw_fq1 -fq2 raw_fq2 -list dup.list -out1 dup_rm_fq1 -out2 dup_rm_fq2
