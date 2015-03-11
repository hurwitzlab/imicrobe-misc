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
use Text::RecordParser;

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

    @ARGV or pod2usage('No files');

    process(@ARGV);

    say "Done.";
}

#-------------------------------------------------------------
sub process {
    for my $file (@_) {
        say "Processing file '$file'";
        my $p         = Text::RecordParser->new($file);
        my $db        = IMicrobe::DB->new;
        my $dbh       = $db->dbh;
        my $schema    = $db->schema;
        my $files     = $schema->resultset('SampleFile');
        my $file_type = "reads_file";

        my ($SampleFileType) =
            $schema->resultset('SampleFileType')->find_or_create({
                type => $file_type
            });
        
        my $i;
        while (my $rec = $p->fetchrow_hashref) {
            my $sample_id   = $rec->{'sample_id'} or next;
            my $sample_file = $rec->{'file'}      or next;
            printf "%5d: %s => %s\n", ++$i, $sample_id, $sample_file;

            my ($SampleFile) = $schema->resultset('SampleFile')->find_or_create(
                {
                    sample_id           => $sample_id,
                    sample_file_type_id => $SampleFileType->id,
                    file                => $sample_file
                }
            );
        }

        say "Processed $i";
    }
}
