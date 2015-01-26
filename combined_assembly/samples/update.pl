#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use JSON::XS 'decode_json';
use IMicrobe::DB;
use Perl6::Slurp 'slurp';

my %skip = map { $_, 1 } qw[ sample_accession_number ncgr_sample_id ];

my $db = IMicrobe::DB->new->dbh;

for my $file (@ARGV) {
    say $file;
    my $json = decode_json(slurp($file));
    #say dump($json);
    my $sample_id = $db->selectrow_array(
        'select sample_id from sample where sample_acc=?', {},
        $json->{'sample_accession_number'}
    );

    if (!$sample_id) {
        say STDERR "Can't find $json->{'sample_accession_number'}";
        next;
    }

    say "Acc $json->{'sample_accession_number'} -> Sample $sample_id";

    while (my ($fld, $val) = each %$json) {
        next if $skip{ $fld };
        next unless $val;
        my $cur = $db->selectrow_array(
            "select $fld from sample where sample_id=?", {}, $sample_id
        ) // '';

        if (!$cur || ($cur ne $val)) {
            #say "$fld: '$cur' => '$val'";
            $db->do(
                "update sample set $fld=? where sample_id=?", {},
                ($val, $sample_id)
            );        
        }
    }
}

say "Done.";
