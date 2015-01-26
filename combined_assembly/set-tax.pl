#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use JSON::XS 'decode_json';
use IMicrobe::DB;
use Text::RecordParser::Tab;

my $f  = shift or die 'No file';
my $p  = Text::RecordParser::Tab->new($f);
my $db = IMicrobe::DB->new->dbh;
my $i  = 0;

while (my $r = $p->fetchrow_hashref) {
    my $sample_id = $r->{'sample_id'};
    printf "%5d: %s\n", ++$i, $sample_id;

    while (my ($fld, $val) = each %$r) {
        next unless $val;
        my $cur = $db->selectrow_array(
            "select $fld from sample where sample_id=?", {}, $sample_id
        ) // '';
        #next if $cur;

        if (!$cur || ($cur ne $val)) {
            say "      $fld: '$cur' => '$val'";
#            $db->do(
#                "update sample set $fld=? where sample_id=?", {},
#                ($val, $sample_id)
#            );        
        }
    }
}

say "Done.";
