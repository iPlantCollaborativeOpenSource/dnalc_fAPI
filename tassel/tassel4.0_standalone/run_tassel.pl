#!/usr/bin/perl -w
use strict;
my $libdir = './tassel4.0_standalone/lib';
opendir (DIR, "$libdir") || die "Could not open $libdir\n";
my @list = readdir(DIR);

my @fl = ();
foreach my $fn(@list){
    if ("$fn" =~ m/\.jar$/){
	push(@fl, "$libdir\/$fn");
    }
}
push(@fl, "./tassel4.0_standalone/sTASSEL.jar");
my $CP = join(":", @fl);
print $CP;
print "\n";
my @args = @ARGV;

system "java -d64 -Xms512m -Xmx1g -classpath '$CP' net.maizegenetics.pipeline.TasselPipeline @args";
