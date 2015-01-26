#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Data::Dump 'dump';
use WWW::Mechanize;
use HTML::LinkExtractor;
use HTML::Strip;
use JSON::XS 'decode_json';

my $FETCH_URL = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi' 
              . '?db=taxonomy&retmode=json&id=';
my $DETAILS_URL = 'http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi'
                . '?mode=Info&lvl=3&keep=1&srchmode=1&unlock&lin=f&id=';

my %want = map { $_, 1 } qw[ phylum class family ];
my $www  = WWW::Mechanize->new;
my $hs   = HTML::Strip->new;
my $lx   = HTML::LinkExtractor->new;
my $db   = IMicrobe::DB->new->dbh;

my @tax_flds = qw[prelim_ncbi_taxon_id taxon_id];

my $samples 
    = $db->selectall_arrayref('select * from sample', { Columns => {} });
say STDERR sprintf "Processing %s samples", scalar @$samples;

my %seen;
my $updated = 0;
my @out_flds = ('sample_id', (keys %want), qw[genus species]);

say join "\t", @out_flds;

SAMPLE:
for my $sample (@$samples) {
    for my $fld (@tax_flds) {
        my $tax_id = $sample->{$fld} or next;

        printf STDERR "%s (%s): %s => %s\n", 
            $sample->{'sample_name'}, $sample->{'sample_id'}, $fld, $tax_id;

        if (!$seen{ $tax_id }) {
            my $res = $www->get($FETCH_URL . $tax_id);
            if ($res->is_success) {
                my $data  = decode_json($res->decoded_content);
                my %class = %{ $data->{'result'}{ $tax_id } };

                my $r2 = $www->get($DETAILS_URL . $tax_id);
                if ($r2->is_success) {
                    my $details = $r2->decoded_content;
                    $lx->parse(\$details);

                    for my $link (@{ $lx->links }) {
                        my $alt = $link->{'alt'} or next;
                        if ($want{ $alt }) {
                            (my $text = $hs->parse($link->{'_TEXT'})) 
                                =~ s/^\s+|\s+$//g;

                            $class{ $alt } = $text;
                        }
                    }
                }

                $seen{ $tax_id } = \%class;
            }
            else {
                say STDERR "Couldn't fetch $tax_id";
            }
        }

        my %data = %{ $seen{ $tax_id } };
        #say join "\n", "tax ($tax_id)", dump(\%data);
        say join "\t", $sample->{'sample_id'}, 
            map { $data{$_} || '' } @out_flds;

        $updated++;
    }
}

say STDERR "Done, updated $updated.";
