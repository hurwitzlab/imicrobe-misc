#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use WWW::Mechanize;
use HTML::TableExtract;
use List::MoreUtils 'zip';
use JSON::XS;

my $url = 
  'http://www.broadinstitute.org/annotation/viral/Phage/ApprovedStrains.html';
my $www = WWW::Mechanize->new;
my $res = $www->get($url);

if (!$res->is_success) {
    die "Can't get $url";
}

my $content = $res->decoded_content;
my $tx = HTML::TableExtract->new;
$tx->parse($content);
my $coder = JSON::XS->new->ascii->pretty->allow_nonref;

my $tbl_num = 0;
for my $tbl ($tx->tables) {
    my @rows   = $tbl->rows;
    my @header =
        map {
            $_ //= '';
            s/^\s+|\s$//g;
            s/[\s\/]+/_/g;
            s/[^\w_]//g;
            lc $_
        }
        @{ shift @rows };

    my @table;
    for my $row (@rows) {
        my @data;
        for my $col (@$row) {
            $col //= '';
            $col =~ s/^\s+|\s+$//g;
            push @data, $col;
        }

        my %row = zip @header, @data;

        push @table, \%row;
    }
    open my $fh, '>', join('', 'table', ++$tbl_num, '.json');
    binmode $fh, ':utf8';
    print $fh $coder->encode(\@table);
    close $fh;
}
