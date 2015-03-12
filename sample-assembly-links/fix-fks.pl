#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;

my $db = IMicrobe::DB->new;
my $schema = $db->schema;
my $Samples = $schema->resultset('Sample');
my $i;

while (my $Sample = $Samples->next) {
#    if (my $assembly_acc = $Sample->assembly_accession_number) {
#        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;
#        my ($Assembly) = $schema->resultset('Assembly')->search({
#            assembly_code => $assembly_acc
#        });
#    
#        if ($Assembly) {
#            printf "     => %s (%s)\n", 
#                substr($Assembly->assembly_name, 0, 70), $Assembly->id;
#            $Assembly->sample_id($Sample->id);
#            $Assembly->update;
#        }
#        else {
#            $Sample->assembly_accession_number(undef);
#            $Sample->update;
#            print STDERR "Can't find assembly code '$assembly_acc'\n";
#        }
#    }

    if (my $ca_name = $Sample->combined_assembly_name) {
        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;
        my ($CA) = $schema->resultset('CombinedAssembly')->search({
            assembly_name => $ca_name
        });
    
        if ($CA) {
            printf "     => %s (%s)\n", 
                substr($CA->assembly_name, 0, 70), $CA->id;
            $Sample->combined_assembly_id($CA->id);
            $Sample->update;
        }
        else {
            $Sample->combined_assembly_name(undef);
            $Sample->update;
            print STDERR "Can't find combined assembly code '$ca_name'\n";
        }
    }
}

say "Done.";
