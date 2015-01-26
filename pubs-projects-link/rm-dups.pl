#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Data::Dump 'dump';

my $db   = IMicrobe::DB->new->dbh;
my $dups = $db->selectall_arrayref(
    q'
        select count(publication_id) as count, pubmed_id 
        from   publication 
        where  pubmed_id is not null
        group by 2 
        having count > 1
    ',
    { Columns => {} }
);

for my $dup (@$dups) {
    my $pub_ids = $db->selectcol_arrayref(
        'select publication_id from publication where pubmed_id=? order by 1', 
        {},
        $dup->{'pubmed_id'}
    );

    my $keep = shift @$pub_ids;

    printf "Pubmed %s has %s records, keep %s, dump %s\n", 
        $dup->{'pubmed_id'}, 
        $dup->{'count'}, 
        $keep,
        join(', ', @$pub_ids);

    for my $pub_id (@$pub_ids) {
        $db->do('delete from publication where publication_id=?', {}, $pub_id);
    }
}

say "Done.";
