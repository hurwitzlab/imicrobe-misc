#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use LWP::Simple 'get';
use JSON::XS 'decode_json';
use Readonly;

Readonly my $URL => "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
                 .  "esummary.fcgi?db=pubmed&id=%s&retmode=json";

main(@ARGV);

# --------------------------------------------------
sub main {
    my $file = shift or die 'No file';

    open my $in, '<', $file;

    my @pubs;
    while (my $pmid = <$in>) {
        chomp $pmid;
        if (my $json = decode_json(get(sprintf($URL, $pmid)))) {
            if (my $pubmed = $json->{'result'}{ $pmid }) {
                push @pubs, $pubmed;
            }
        }
    }

    close $in;

    my $coder = JSON::XS->new->pretty;
    binmode STDOUT, ':utf8';
    print $coder->encode(\@pubs);

    say STDERR "Done.";
}
