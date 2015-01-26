#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Text::TabularDisplay;

my $db = IMicrobe::DB->new->dbh;
my $missing = $db->selectall_arrayref(
    q'
        select p.project_id, left(p.project_name, 50) as project_name,
               count(s.sample_id) as num_missing
        from   sample s, project p
        where  s.project_id=p.project_id
        and    s.reads_file is null
        group by 1, 2
        order by 3
    ',
    { Columns => {} }
);

for my $m (@$missing) {
#    $m->{'project_name'} = sprintf(
#        '<a href="http://data.imicrobe.us/project/view/%s">%s</a>', 
#        $m->{'project_id'}, $m->{'project_name'}
#    );

    $m->{'num_samples'} = $db->selectrow_array(
        'select count(*) from sample where project_id=?', {}, 
        $m->{'project_id'}
    );

    $m->{'pct_missing'} = sprintf(
        "%11d", int(100 * ($m->{'num_missing'} / $m->{'num_samples'}))
    );
}

my @data = sort { $b->{'pct_missing'} <=> $a->{'pct_missing'} } @$missing;

my @flds = qw'project_id project_name num_samples num_missing pct_missing';
my $tab  = Text::TabularDisplay->new(@flds);
for my $d (@data) {
    $tab->add( map { $d->{ $_ } } @flds );
}
say $tab->render, "\n";
