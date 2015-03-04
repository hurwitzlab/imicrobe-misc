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
    my $db     = IMicrobe::DB->new;
    my $dbh    = $db->dbh;
    my $schema = $db->schema;
    my $files  = $dbh->selectall_arrayref(
        'select * from sample_file_type',
        { Columns => {} },
    );
    my $i;

    for my $file (@$files) {
        print "\n $file->{'sample_file_type_id'} => $file->{'type'} \n";
        my $file_type = $file->{'type'};
        my $samples   = $dbh->selectall_arrayref(
            sprintf(
                'select sample_id, %s as file from sample where %s is not null',
                $file_type, $file_type
            ),
            { Columns => {} },
        );

        for my $sample (@$samples) {
            my $file_name = $sample->{'file'} or next;
            printf "%5d: %s %s => %s\n", 
                ++$i,
                $sample->{'sample_id'}, 
                $file_type,
                $file_name,
            ;

#            $dbh->do(
#                q[insert into sample_file
#                    (sample_id,sample_file_type_id,file_value)
#                     values (?,?,?)],
#                {},
#                (
#                    $sample->{'sample_id'}, $file->{'sample_file_type_id'},
#                    $sample->{'file_value'}
#                )
#            );
        }
    }
}
