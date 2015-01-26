#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use Data::Dump 'dump';
use autodie;
use IMicrobe::DB;
use Text::RecordParser;

main(@ARGV);

sub main {
    my $file   = shift or die 'No file';
    my $p      = Text::RecordParser->new($file);
    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;
    my $i      = 0;

    while (my $rec = $p->fetchrow_hashref) {
        #say dump($rec);
        my $taxon_id  = $rec->{'taxon_id'} or next;
        my ($Samples) = $schema->resultset('Sample')->search_rs({
            taxon_id  => $taxon_id,
        });

        #printf "Found %s samples for %s\n", $Samples->count, $taxon_id;

        while (my $Sample = $Samples->next) {
            for my $fld (qw[family genus superkingdom species]) {
                my $new = $rec->{ $fld }  or next;
                my $cur = $Sample->$fld() // '';

                if ($new ne $cur) {
                    printf "%5d: %s (%s) %s: %s -> %s\n", 
                        ++$i,
                        $Sample->sample_name,
                        $Sample->id,
                        $fld,
                        $cur || "''",
                        $new,
                    ;
                    $Sample->$fld($new);
                    $Sample->update;
                }

                if ($fld eq 'species' && $new eq $Sample->strain) {
                    $Sample->strain(undef);
                    $Sample->update;
                }
            }
        }
    }

    say "Done.";
}
