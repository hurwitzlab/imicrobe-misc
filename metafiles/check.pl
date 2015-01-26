#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use IMicrobe::DB;
use File::Basename 'basename';
use File::Spec::Functions 'catfile';

my $db     = IMicrobe::DB->new;
my $Schema = $db->schema;

my @sample_fields = qw(
    reads_file annotations_file peptides_file contigs_file cds_file
);

my @project_fields = qw(
    read_file meta_file assembly_file peptide_file read_pep_file nt_file
);

my $ProjectI = $Schema->resultset('Project');
while (my $Project = $ProjectI->next) {

    my @bad;
    for my $fld (@project_fields) {
        my $val = $Project->$fld() or next;
        if ($val !~ m!^/!) {
            #push @bad, { $fld, $val };
            say join "\t", $Project->id, $fld, $val;
            $db->dbh->do(
                "update project set $fld=null where project_id=?", {},
                $Project->id
            );
        }
    }

#    if (@bad) {
#        say join ': ', $Project->project_name, $Project->id;
#        say dump(\@bad), '';
#    }
#    last;
}

say "Done.";
