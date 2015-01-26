#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use WWW::Mechanzie;
use HTML::TableExtract;
use HTML::LinkExtractor;

my $db  = IMicrobe::DB->new->dbh;
my $www = WWW::Mechanize->new;
my $url = "http://camera.crbs.ucsd.edu/mmetsp/list.php";
my $tx  = HTML::TableExtract->new;
my $lx  = HTML::LinkExtractor->new;
my $hs  = HTML::Strip->new;

my $res = $www->get($url);
if ($res->is_success) {
    my $content = $res->decoded_content;
    $lx->parse(\$content);
#        $tx->parse($content);
#        for my $tbl ($tx->tables) {
