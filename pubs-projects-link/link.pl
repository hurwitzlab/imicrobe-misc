#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use Text::RecordParser;
use IMicrobe::DB;

main(@ARGV);

sub main {
    my $file = shift or die 'No file';
    my $p    = Text::RecordParser->new(
        filename        => $file,
        field_separator => ',',
    );

    my $db = IMicrobe::DB->new;
    my $schema = $db->schema;
    my $i;

    while (my $rec = $p->fetchrow_hashref) {
        my $project_id = $rec->{'project_id'} or next;
        my $pubmed_id  = $rec->{'pubmed_id'}  or next;

        my ($Pub) = $schema->resultset('Publication')->search({
            pubmed_id => $pubmed_id
        }) or die "Bad PM id ($pubmed_id)\n";

        printf "%5d: %s (%s) => project %s\n",
            ++$i,
            substr($Pub->title, 0, 50),
            $Pub->id,
            $project_id,
        ;

        $Pub->project_id($project_id);
        $Pub->update();
    }

    say "Done.";
}
