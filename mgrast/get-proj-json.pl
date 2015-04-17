#!/usr/bin/env perl
#
use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use WWW::Mechanize;
use JSON::XS 'decode_json';
#use aish::DB;

my $www  	   = WWW::Mechanize->new;
my $page 	   = 828;
my $url 	   = "http://api.metagenomics.anl.gov/1/project?limit=$page&order=name";
my $res  	   = $www->get($url);
my $meta_url 	   = "http://api.metagenomics.anl.gov/1/project/%s?verbosity=full";

my $count;
if ($res->is_success) {
    my $data = decode_json($res->decoded_content);
    $count = $data->{'total_count'};
}

my $pages = int ($count / $page);

for my $page_num (0..$pages) {
    printf STDERR "Page %3d of %s\n", $page_num, $pages;
    my $r = $www->get($url . "&offset=" . $page_num * $page);
    if ($r->is_success) {
        my $data = decode_json($res->decoded_content);

        for my $id (map { $_->{'id'} } @{$data->{'data'}}) {
            printf STDERR "  id => $id\n";
            my $r2 = $www->get(sprintf($meta_url, $id));

            if ($r2->is_success) {
                open my $fh, '>', './data/projects/' . $id . '.json';
                print $fh $r2->decoded_content;
                
                my $proj_data = decode_json($r2->decoded_content);
                
                for my $library(@{$proj_data->{libraries}}){
                    printf STDERR $library->[1];
                        my $r3 = $www->get($library->[1].'?verbosity=full');
                        if ($r3->is_success)  {
                        open my $fh, '>', './data/libraries/' . $library->[0] . '.json';
                        print $fh $r3->decoded_content;
                    } 
                }
                
                for my $metagenome(@{$proj_data->{metagenomes}}){
		    eval{
                    	printf STDERR  $metagenome->[0];
                        my $r4 = $www->get($metagenome->[1].'?verbosity=metadata');
                        if ($r4->is_success) {
                        open my $fh, '>', './data/metagenomes/' . $metagenome->[0] . '.json';
                         print $fh $r4->decoded_content;
                    	} 
               	    };
		    warn $@ if $@;	
		    open(my $fh, '>','./data/Error.txt') or die
                }

                for my $sample(@{$proj_data->{samples}}){
                    printf STDERR $sample->[0];
                        my $r5 = $www->get($sample->[1].'?verbosity=full');
                        if ($r5->is_success) {
                        open my $fh, '>', './data/samples/' . $sample->[0] . '.json';
                         print $fh $r5->decoded_content;
                    } 
                }
                close $fh;
            }
        }
    }
}
say "Done.";
