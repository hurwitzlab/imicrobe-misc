#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Text::RecordParser;
use Readonly;

Readonly my $PROJECT_ID => 124;

my $db = IMicrobe::DB->new;
my $schema = $db->schema;

#library.csv
#sample.csv
#site.csv

samples($schema, 'sample.csv');
#library($db, 'library.csv');

# --------------------------------------------------
sub samples {
#                sample_name: AntNovFreeVir
#               library_name: AntNovFreeVir
#            collection_date: 11/18/10
#         investigation_type: virus
#                  site_name: WAP:B
#              sample_volume: 20 L
#                 filter_min: 0.22
#                 filter_max:
#  environmental_temperature: 1.0
#     environmental_salinity:
#                      depth: 0
#           dissolved_oxygen:

    my $schema      = shift;
    my $file        = shift;
    my $p           = Text::RecordParser->new($file);
    my $site        = site();
    my @sample_flds = $p->field_list;
    my @site_flds   = keys %$site;

    while (my $rec = $p->fetchrow_hashref) {
        my $sample_name = $rec->{'sample_name'} or next;

        say $sample_name;

        my $Sample = $schema->resultset('Sample')->find_or_create({
            project_id  => $PROJECT_ID,
            sample_name => $sample_name
        });

        for my $fld (@site_flds) {
            (my $val = $site->{$fld}) =~ s/"//g;
            $Sample->$fld($val);
        }

        for my $fld (@sample_flds) {
            $Sample->$fld( $rec->{$fld} );
        }   

        $Sample->update;
    }

    say "Done.";
}

sub site {
#         site_name: WAP:B
#         longitude: -64.0545
#          latitude: -64.7742
#           country: N/A
#     habitata_type: marine
#  site_description: "coastal western Antarctic Peninsula, Palmer, Antarctica LTER Station B"
#            region: "Southern Ocean, western Antarctic Peninsula"

    my $p = Text::RecordParser->new('site.csv');
    return $p->fetchrow_hashref;
}
