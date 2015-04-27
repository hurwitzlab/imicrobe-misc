#!usr/bin/env perl


use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use Pod::Usage;
use Readonly;
use IMicrobe::DB;
use Readonly;
use Text::RecordParser;

main(@ARGV);
#----------------------------------------------------------

sub main {
    my $file    = shift or die "No File";
    my $p       = Text::RecordParser->new($file);
    my $db      = IMicrobe::DB->new;
    my $schema  = $db->schema;
    my $Samples = $schema->resultset('Sample');
    
    while ( my $rec = $p->fetchrow_hashref ) {
        my ($Sample);
        for my $fld (qw[ sample_name sample_code mmetsp_id]) {
            ($Sample) = $schema->resultset('Sample')->search(
                {
                    $fld => $rec->{'sample_name'}
                }
            );

            last if $Sample;
        }
        $Sample->update(
            {
                latitude  => $rec->{lat},
                longitude => $rec->{long}
            }
        );
}
say "Done updating Geographical location"
}
