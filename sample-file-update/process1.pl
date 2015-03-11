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

Readonly my $File => '/home/aish/work/sample-file-update/sample_files.csv';

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
#-------------------------------------------------------------
sub process() {
    my $p         = Text::RecordParser->new($File);
    my $map       = $p->fetchall_hashref('file');
    my $db        = IMicrobe::DB->new;
    my $dbh       = $db->dbh;
    my $schema    = $db->schema;
    my $files     = $schema->resultset('SampleFile');
    my $file_type = "reads_file";

    my ($SampleFileType) =
      $schema->resultset('SampleFileType')->find_or_create(
        {
            type => $file_type
        }
      );
    
    for my $fld ( keys %$map ) {
        next unless $fld;
        print "\n$map->{$fld}{'sample_id'} : $map->{$fld}{'file'}\n";
        my $sample_id    = $map->{$fld}{'sample_id'};
        my $sample_file  = $map->{$fld}{'file'};
        my ($SampleFile) = $schema->resultset('SampleFile')->find_or_create(
            {
                sample_id           => $sample_id,
                sample_file_type_id => $SampleFileType->id,
                file                => $sample_file
            }
        );
    }
}
    # --------------------------------------------------

__END__
