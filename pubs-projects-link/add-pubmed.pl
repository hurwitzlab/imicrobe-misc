#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Data::Dump 'dump';
use JSON::XS 'decode_json';
use Perl6::Slurp 'slurp';

main(@ARGV);

# --------------------------------------------------
sub main {
    my $file   = shift or die 'No file';
    my $pubs   = decode_json(slurp($file));
    my $schema = IMicrobe::DB->new->schema;
    my $added  = 0;
    my %seen;

    for my $pub (@$pubs) {
        my $pubmed_id = $pub->{'uid'} or next;

        next if $seen{ $pubmed_id }++;

        my ($Publication) = $schema->resultset('Publication')->search({
            pubmed_id => $pubmed_id
        });

        if (!$Publication) {
            $added++;
            say "Adding $pubmed_id (", substr($pub->{'title'}, 0, 50), ")";

            my ($doi) = 
                grep { $_->{'idtype'} eq 'doi' } 
                @{ $pub->{'articleids'} || [] }
            ;

            my @authors = map { $_->{'name'} } @{ $pub->{'authors'} || [] };

            $schema->resultset('Publication')->create({
                pubmed_id => $pubmed_id,
                title     => $pub->{'title'},
                journal   => $pub->{'fulljournalname'},
                pub_date  => $pub->{'pubdate'},
                author    => @authors ? join(', ', @authors) : '',
                doi       => ref $doi ? $doi->{'value'} : '',
            });
        }
    }

    say "Done, added $added.";
}
