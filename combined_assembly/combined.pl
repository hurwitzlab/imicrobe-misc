#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use List::MoreUtils 'zip';
use WWW::Mechanize;
use HTML::TableExtract;
use HTML::LinkExtractor;
use IMicrobe::DB;
use JSON::XS 'encode_json';
use Data::Dump 'dump';
use File::Basename 'basename';

my $db  = IMicrobe::DB->new->dbh;
my $www = WWW::Mechanize->new;
my $project_id = 104;
my @take = qw[
    assembly_name phylum class family genus species strain pcr_amp 
];
my %file_type = (
    annot => 'annotations',
    pep   => 'peptides',
    nt    => 'nucleotides',
    cds   => 'cds',
);

my $res = $www->get("http://camera.calit2.net/mmetsp/combinedassemblies.php");
if (!$res->is_success) {
    die "Couldn't get url";
}

my $content = $res->decoded_content;

#
# download links
#
my $lx = HTML::LinkExtractor->new;
$lx->parse(\$content);
my %links;
for my $link (map { $_->{'href'} || () } @{ $lx->links }) {
    say $link if $link =~ /\.annot\./;
    (my $file = basename($link)) =~ s/\.gz$//;
    my ($sample, $type, @rest) = split /\./, $file;
    push @{ $links{$sample} }, {
        file => $file,
        type => $type,
    }
}
exit;

#
# table data
#
my $tx  = HTML::TableExtract->new;
$tx->parse($content);

my $insert_sql = sprintf(
    'insert into combined_assembly (%s) values (%s)',
    join(', ', @take, 'project_id' ),
    join(', ', map { '?' } @take, ''),
);

for my $tbl ($tx->tables) {
    my @rows = $tbl->rows;
    my @flds = map { s/\s+/_/g; s/combined_assembly/assembly_name/i; lc $_ } 
        @{ shift @rows };

    for my $row (@rows) {
        my %row  = zip(@flds, @$row);
        my $name = $row{'assembly_name'} or next;
        my @vals = map { $row{ $_ } } @take;

        $db->do($insert_sql, {}, (@vals, $project_id));

        my $combined_assembly_id = $db->selectrow_array(
            'select last_insert_id()'
        );

        say "$name ($combined_assembly_id)";

        #
        # add downloads
        #
        for my $file (@{ $links{ $name } }) {
            my $ft = $file_type{ $file->{'type'} } . '_file';
            $db->do(
                "update combined_assembly set $ft=?", {}, $file->{'file'}
            );
        }

        #
        # add samples
        #
        for my $sample ( split(/\s*,\s*/, $row{'samples'} || '') ) {
            $sample =~ s/^\s+|\s+$//g;

            if (my $sample_id = find_sample_id($db, $sample)) {
                say "sample ($sample): $sample_id";
                $db->do(
                    q[
                        insert 
                        into   combined_assembly_to_sample 
                               (combined_assembly_id, sample_id)
                        values (?, ?)
                    ],
                    {},
                    ($combined_assembly_id, $sample_id)
                );
            }
            else {
                say STDERR "Can't find sample ($sample)";
            }
        }
    }
}

say "Done.";

sub find_sample_id {
    my ($db, $sample_name) = @_;
    my $sample_id = $db->selectrow_array(
        'select sample_id from sample where sample_name=?', {}, $sample_name
    );

    if (!$sample_id) {
        my $sql = sprintf(
            'select sample_id from sample where sample_name like "%s%%"',
            $sample_name
        );
        say STDERR $sql;

        $sample_id = $db->selectrow_array($sql);
    }

    if (!$sample_id) {
        my $sql = sprintf(
            'select sample_id from sample where biomaterial_name like "%%%s%%"',
            $sample_name
        );

        $sample_id = $db->selectrow_array($sql);
    }

    $sample_id;
}
