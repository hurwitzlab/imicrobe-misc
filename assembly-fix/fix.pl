#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Perl6::Slurp 'slurp';
use File::Basename 'basename';
use Data::Dump 'dump';

my %files   = map { chomp; basename($_), $_ } slurp('list');
my $db      = IMicrobe::DB->new;
my $schema  = $db->schema;
my $i       = 0;
my $changed = 0;

#my $AsmIt   = $schema->resultset('Assembly');
#while (my $Asm = $AsmIt->next) {
#    printf "%5d: %s (%s)\n", ++$i, $Asm->assembly_name, $Asm->id;
#
#    for my $fld (qw'pep_file nt_file cds_file') {
#        my $name = basename($Asm->$fld() || '') or next;
#        $name    =~ s/\.gz$//;
#        my $path = $files{ $name } or next;
#        say ' ' x 8, "$fld: $name => $path";
#        $Asm->$fld($path);
#        $Asm->update;
#        $changed++;
#    }
#}

my $ComAsmIt = $schema->resultset('CombinedAssembly');

while (my $Asm = $ComAsmIt->next) {
    printf "%5d: %s (%s)\n", ++$i, $Asm->assembly_name, $Asm->id;

    for my $fld (qw'annotations_file peptides_file nucleotides_file cds_file') 
    {
        my $name = basename($Asm->$fld() || '') or next;
        $name    =~ s/\.gz$//;
        my $path = $files{ $name } or next;
        say ' ' x 8, "$fld: $name => $path";
        $Asm->$fld($path);
        $Asm->update;
        $changed++;
    }
}

say "Done, changed $changed.";
