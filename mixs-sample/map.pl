#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Perl6::Slurp 'slurp';
use Text::RecordParser;
use Data::Dump 'dump';

main();

# --------------------------------------------------
sub main {
    my $field_map = field_map();
    my $schema    = IMicrobe::DB->new->schema;
    my $SamplesI  = $schema->resultset('Sample');

    printf "Processing %s samples\n", $SamplesI->count;

    my $i = 0;
    while (my $Sample = $SamplesI->next) {
        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;    
        sample($schema, $Sample, $field_map);
        last;
    }

    say "Done.";
}

# --------------------------------------------------
sub field_map {
    my $p = Text::RecordParser->new('field-map.csv');
    return $p->fetchall_arrayref({ Columns => {} });
}

# --------------------------------------------------
sub sample {
    my ($schema, $Sample, $field_map) = @_;

    my %valid = map { $_, 1 } $Sample->result_source->columns;

    for my $def (@$field_map) {
        my $fld = $def->{'imicrobe'} or next;
        next unless $valid{ $fld };

        my $category  = $def->{'category'} or next;
        next if $category =~ /^\?+$/; # skip "???"

        my $mixs_term = $def->{'mixs_term'} or next;
        my $val       = $Sample->$fld()     or next;

        print "$fld -> $mixs_term ($category)\n";
        say $val, "\n";
    }
}
