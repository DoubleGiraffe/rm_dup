#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Cwd 'abs_path';
use Compress::Zlib;

sub usage {
        print <<USAGE;
usage:
        perl $0 [options]
author
        wanglu   wanglu\@frasergen.com
description:

options:
        -help: print help info
        -fq1    *   <str>  : input 1.fq
        -fq2    *   <str>  : input 2.fq
        -out    *   <str>  : output
                             
                             
e.g.:
        perl $0 -fq1 input_1.fq -fq2 input_2.fq -out output
USAGE
}

my ($help,$fq1,$fq2,$out);
GetOptions(
        "help"=>\$help,
        "fq1=s"=>\$fq1,
        "fq2=s"=>\$fq2,
        "out=s"=>\$out,
         );
if (defined $help || (!defined $fq1) || (!defined $fq2) || (!defined $out)) {
        &usage();
        exit 0;
}

my $fq1gz = gzopen($fq1,"rb") or die "error open $fq1";
my $fq2gz = gzopen($fq2,"rb") or die "error open $fq2";
my %hash;
my %Seq;

open OUT,'>',"$out" or die "can't open $out\nDied ";
while( 1 ){
	my (@q1,@q2);
        for (my $i=0;$i<4 ;$i++) {
                $fq1gz->gzreadline($q1[$i]);
                $fq2gz->gzreadline($q2[$i]);

                if (defined $q1[$i] && defined $q2[$i]){
                        chomp ($q1[$i],$q2[$i]);
                }else{
                        last;
                }
        }
        unless (defined $q1[3] && defined$q2[3]){
                last;### 当 fq 读完时 退出循环
        }
	$q1[1]=substr($q1[1],7,106);
	$q2[1]=substr($q2[1],7,106);
	my $id=$1 if($q1[0]=~/^(\S+)/);
	if ( exists $Seq{"$q1[1]$q2[1]"} ){
		$Seq{"$q1[1]$q2[1]"}++;
		$hash{"$q1[1]$q2[1]"}.="\t$id";
	}else{
		$Seq{"$q1[1]$q2[1]"}=1;
		$hash{"$q1[1]$q2[1]"}=$id;
		
	}
}

foreach(keys %hash){
	if($Seq{$_}>1){
		print OUT "$hash{$_}\n";
	}
}
close OUT;
