#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use WWW::Mechanize;
use File::Basename 'basename';
use HTML::TableExtract;
use HTML::LinkExtractor;
use HTML::Strip;
use IMicrobe::DB;
use JSON::XS 'encode_json';
use List::MoreUtils 'zip';

my $db  = IMicrobe::DB->new->dbh;
my $www = WWW::Mechanize->new;
my $url = "http://camera.calit2.net/mmetsp/list.php";
my $tx  = HTML::TableExtract->new;
my $lx  = HTML::LinkExtractor->new;
my $hs  = HTML::Strip->new;

my $res = $www->get($url);
my $i;
if ($res->is_success) {
    my $content = $res->decoded_content;

    $lx->parse(\$content);
    my %link;
    for my $link (@{ $lx->links }) {
        my $href = $link->{'href'} or next;
        if ($href =~ /details\.php\?id=(\w+)/) {
            my $id = $1;
            (my $ncgr_id = $hs->parse($link->{'_TEXT'} || '')) =~ s/^\s+|\s+$//;
            $link{ $ncgr_id } = $id;
        }
    }

    $tx->parse($content);
    for my $tbl ($tx->tables) {
        my @rows   = $tbl->rows;
        my @header = 
            map { 
                s/\s\*//; 
                s/\s+/_/g; 
                s/[^\w_]//g;  
                s/principle_investgators/pi/i;
                lc $_ 
            } 
            @{ shift @rows };

        for my $row (@rows) {
            my @data = map { s/^\s+|\s+$//g; $_ } @$row;
            my $id   = $data[0];
            my %data = zip @header, @data;

            my $sample_name = $link{$id} or die "No sample name for $id";

            my $sample_id = $db->selectrow_array(
                'select sample_id from sample where sample_name=?', {},
                $sample_name
            );

            printf "%5d: %s -> %s (%s)\n", ++$i, $id, $sample_name, $sample_id;

            while (my ($fld, $val) = each %data) {
                next unless $val;
                my $cur = $db->selectrow_array(
                    "select $fld from sample where sample_id=?", {}, $sample_id
                ) // '';

                if (!$cur || ($cur ne $val)) {
                    printf "%20s: '%s' => '%s'\n", $fld, $cur, $val;
                    $db->do(
                        "update sample set $fld=? where sample_id=?", {},
                        ($val, $sample_id)
                    );        
                }
            }
        }
    }
}

say "Done.";
