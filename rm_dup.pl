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
        -list    *   <str>  : input duplication list
        -fq1     *   <str>  : input fq1
	-fq2     *   <str>  : input fq2
        -out1    *   <str>  : output fq1
	-out2    *   <str>  : output fq2
                             
                             
e.g.:
        perl $0 -list dup.list -fq1 input1.fq -fq2 input2.fq -out1 output1 -out2 output2
USAGE
}

my ($dup_list,$fq1,$fq2,$out1,$out2,$help);
GetOptions(
        "help"=>\$help,
        "list=s"=>\$dup_list,
        "fq1=s"=>\$fq1,
	"fq2=s"=>\$fq2,
        "out1=s"=>\$out1,
	"out2=s"=>\$out2,
         );
if (defined $help || (!defined $dup_list) || (!defined $fq1) ||(!defined $fq2) || (!defined $out1) || (!defined $out2)) {
        &usage();
        exit 0;
}

my %hash;
my %flag;

open IN,$dup_list;
my $n=0;
while(<IN>){
	$n++;
	chomp;
	my @a=split /\s+/,$_;
	foreach my $a(@a){
		$hash{$a}=$n;
	}
}
close IN;

$/='@';
open IN1,$fq1;
open OUT1,">$out1";
<IN1>;
while(<IN1>){
	chomp;
	my @a=split/\n/,$_;
	my $key="\@$1" if($a[0]=~/^(\S+)/);
	if(exists $hash{$key}){
		if(!exists $flag{$hash{$key}}){
			print OUT1 "\@$_";
			$flag{$hash{$key}}=1;
		}
	}else{
		print OUT1 "\@$_";
	}
}
close IN1;
close OUT1;

%flag=();
open IN2,$fq2;
open OUT2,">$out2";
<IN2>;
while(<IN2>){
        chomp;
        my @a=split/\n/,$_;
        my $key="\@$1" if($a[0]=~/^(\S+)/);
        if(exists $hash{$key}){
                if(!exists $flag{$hash{$key}}){
                        print OUT2 "\@$_";
                        $flag{$hash{$key}}=1;
                }
        }else{
                print OUT2 "\@$_";
        }
}
close IN2;
close OUT2;
