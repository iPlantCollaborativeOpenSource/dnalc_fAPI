#!/usr/bin/perl -w
use strict;

chdir 'cufflinks_out' or die $!;

print STDERR "List of files", `ls -al`, "\n";;

open ISOFORMS, "grep OK isoforms.fpkm_tracking |" or die $!;

# record all transcripts with OK status and FPKM > 0;
my %isoform;
while (<ISOFORMS>) {
    my ($transcript,$fpkm)  = (split)[0,8];
    next unless $fpkm;
    $isoform{$transcript}++;
}

# print only transcript GTF that passes above tests
open TRANSCRIPTS, "transcripts.gtf" or die $!;
open OUT, ">expressed_transcripts.gtf" or die $!;

while (<TRANSCRIPTS>) {
    my ($t_id) = /transcript_id "([^"]+)"/;
    $t_id || next;
    $isoform{$t_id} || next;
    print OUT $_;
}


print STDERR "Done with expressed transcripts\n";




