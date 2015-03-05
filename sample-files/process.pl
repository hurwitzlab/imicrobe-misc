#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;


main();

# --------------------------------------------------
sub main {
    my ($help, $man_page);
    GetOptions(
        'help' => \$help,
        'man'  => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    };

    process();
}

# --------------------------------------------------
sub process {
    my $db      = IMicrobe::DB->new;
    my $dbh     = $db->dbh;
    my $schema  = $db->schema;
    my $Samples = $schema->resultset('Sample');
    my $i       = 0;
    my @types   = qw[ reads_file annotations_file 
        cds_file peptides_file contigs_file fastq_file 
    ];

    while (my $Sample = $Samples->next) {
        for my $type (@types) {
            if (my $file = $Sample->$type()) {
                my ($SampleFileType) =
                    $schema->resultset('SampleFileType')->find_or_create({
                        type => $type
                    });

                my ($SampleFile) = 
                    $schema->resultset('SampleFile')->find_or_create({
                        sample_id           => $Sample->id,
                        sample_file_type_id => $SampleFileType->id,
                        file                => $Sample->$type
                });
            }
        }
    }
}    

