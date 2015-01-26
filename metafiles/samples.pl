#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use File::Basename 'basename';
use File::Spec::Functions 'catfile';

my $db         = IMicrobe::DB->new;
my $Schema     = $db->schema;
my $sample_dir = '';
my $project_id = '';
my %sample_name_to_id = ();

LINE:
for my $line (<DATA>) {
    chomp $line;

    if ($line =~ m!^\s+C-\s+!) {
        next LINE;
    }
    elsif ($line =~ m!(\d+)/transcriptomes/MMETSP\d+:$!) {
        $project_id = $1;
        ($sample_dir = $line) =~ s/:$//;
        next LINE;
    }
    elsif ($line =~ m!^/!) {
        ($project_id, $sample_dir) = ('', '');
        next LINE;
    }
    elsif ($sample_dir && $line =~ /\.(fa|tar)$/) {
        (my $file = $line) =~ s/^\s+|\s+$//g;
#        my $sample_name = basename($file, '.fa');
        my ($sample_name, $ftype, $ext) = split /\./, $file;

        my $Sample;
        if (my $sample_id = $sample_name_to_id{ $sample_name }) {
            $Sample = $Schema->resultset('Sample')->find($sample_id);
        }
        else {
            FLD:
            for my $fld (
                qw[ sample_name sample_acc description sample_description]
            ) {
                for my $suffix ('', '_2', 'C', '_C', '_2C') {
                    ($Sample) = $Schema->resultset('Sample')->search({ 
                        $fld       => join('', $sample_name, $suffix),
                        project_id => $project_id,
                    });
                    last FLD if $Sample;
                }
            }
        }

        if (!$Sample) {
            print STDERR "Can't find $sample_name\n";
            next LINE;
        }

        my %ft = (
            nt    => 'reads_file',
            pep   => 'peptides_file',
            cds   => 'cds_file',
            fastq => 'fastq_file',
        );

        my $dest_file = catfile($sample_dir, $file);
        my $dest_fld  = $ft{ $ftype } or die "Unknown type ($ftype) on $file\n";
        printf "%s (%s) %s => %s\n", 
            $Sample->sample_name, $Sample->id, $dest_fld, $dest_file;
        $Sample->$dest_fld($dest_file);
        $Sample->update;
    }
}

say "Done.";
