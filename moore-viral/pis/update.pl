#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use JSON::XS 'decode_json';
use Perl6::Slurp 'slurp';
use Readonly;

Readonly my $PROJECT_ID => 12;

my $db      = IMicrobe::DB->new;
my $schema  = $db->schema;
my $json    = decode_json(slurp('table1.json'));
my $i       = 0;
my $missing = 0;
my $updated = 0;

REC:
for my $rec (@$json) {
    my $sample_name = $rec->{'genus_species_strain_or_virome'} or next;
    my $pi          = $rec->{'researcher'} or next;

    printf "%5d: %s -> %s\n", ++$i, $sample_name, $pi;

    my $Sample;
    for my $fld (qw[sample_name strain]) {
        ($Sample) = $schema->resultset('Sample')->search({
            project_id => $PROJECT_ID,
            $fld       => $sample_name,
        });

        last if $Sample;
    }

    if (!$Sample) {
        say STDERR qq[Can't find "$sample_name"];
        $missing++;
        next REC;
    }

    my $cur = $Sample->pi || '';

    if ($cur ne $pi) {
        $updated++;
        printf qq[  "%s" => "%s"\n], $cur, $pi;
    }
}

say "Done, processed $i, missing $missing, updated $updated.";
