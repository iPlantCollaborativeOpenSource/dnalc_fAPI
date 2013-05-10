#!/usr/bin/perl
use strict;
use common::sense;

use lib '/home/smckay/lib';

use AnyEvent;
use IO::File ();
use File::Spec ();
use iPlant::FoundationalAPI::Constants ':all';
use iPlant::FoundationalAPI ();
use Data::Dumper;
use File::Basename;

use constant DEBUG => 0;
use constant iPLANT_USER  => $ENV{USER};
use constant iPLANT_TOKEN => $ENV{TOKEN};

my $cluster = shift || 'stampede';

my $api_instance = iPlant::FoundationalAPI->new(
    debug => DEBUG,
    user  => iPLANT_USER,
    token => iPLANT_TOKEN,
    );

die "Can't auth.." unless $api_instance->auth;
if ($api_instance->token eq kExitError) {
    print STDERR "Can't authenticate!" , $/;								
}

print "Token: ", $api_instance->token, "\n";

my $apps = $api_instance->apps;
my ($cl) = $apps->find_by_name("cufflinks-$cluster");
if ($cl) {
    print "Found App ", $cl->name, "\n";
    print STDERR Dumper( $cl ), $/ if DEBUG;
}
else {
    print STDERR  "App [cufflinks] not found!!", $/;
    exit -1;
}

my $io = $api_instance->io;

my $base_dir = '/' . $api_instance->user;
print "Working in [", $base_dir, "]", $/;

my $job_ep = $api_instance->job;
$job_ep->debug(DEBUG);

my $job_id;

my $int = int(rand()*1000);
my %params = (
    jobName => "cl$int",
    archive => 1,
    archivePath => "/smckay/API_test/cufflinks/$cluster-$int",
    processors => 1,
    requestedTime => '04:00:00',
    softwareName => $cl->name,
    query1 => '/smckay/cuffdiff_test/WT_rep1.bam',
    BIAS_FASTA => '/smckay/cuffdiff_test/genome.fas',
    #annotation => '/smckay/cuffdiff_test/annotation.gtf',
    preMrnaFraction => 0.15,
    noFauxReads => 0,
    trim3avgcovThresh => 10,
    intronOverhangTolerance => 10,
    trim3dropoffFrac => 0.1,
    minFragsPerTransfrag => 10,
    libraryType => 'fr-unstranded',
    minIsoformFraction => 0.1,
    upperQuartileNorm => 0,
    overhangTolerance3 => 600,
    maxBundleLength => 3500000,
    smallAnchorFraction => 0.09,
    maxIntronLength => 300000,
    minIntronLength => 50,
    overhangTolerance => 10,
    multiReadCorrect => 0,
    minAlignmentCount => 5,
    );

my $job = $job_ep->submit_job($cl, %params), $/;
if ($job != kExitError) {
    $job_id = $job->{data}->{id};
    print STDERR  "JOB_ID: ", $job_id, $/;
}
else {
    print STDERR  "Failed to submit job..", $/;
}

unless ($job_id) {
    die "Job not submitted..\n", Dumper $job;
}

print STDERR  "Polling for job status..", $/;

my $i = 40;
my $cv = AnyEvent->condvar;
my $w = AnyEvent->timer (after => 30, interval => 30,
			 cb => sub {
			     my $st = $job_ep->job_details($job_id);
			     $i--;
			     $cv->send($job_id) if $st->{status} =~ /FINISHED$/;
			     $cv->send unless $i;
			     print $job_id, "\t", $st->{status}, $/;
			 }
    );

my ($file_list_path) = $cv->recv;

undef $w;

