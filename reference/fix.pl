#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;

my $db = IMicrobe::DB->new;
my $schema = $db->schema;

local $/ = '>';

while (my $rec = <DATA>) {
    chomp $rec;
    next unless $rec;

    my ($name, $desc) = split /\n/, $rec, 2;

    my ($Reference) = $schema->resultset('Reference')->search({
        name => $name
    }) or die "Can't find $name";

    printf "%s => %s\n", $name, $Reference->id;

    $Reference->description($desc);
    $Reference->update;
}

say "Done.";

__DATA__
>CAMERA Non-human Eukaryotic Nucleotide Sequences (N)
This data set contains non-redundant eukaryotic nucleotide sequences from publicly available resources. Human sequences are exluded from this data set. Sequences less than 50 bases are also excluded from this set. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. Sequences from environmental samples are not included in this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195
>CAMERA Non-human Eukaryotic Proteins (P)   
This data set contains non-redundant proteins of all eukaryotic organisms except human from publicly available resources. Peptide sequences that are less than 10 amino acids are excluded from this set. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. Sequences from environmental samples are not included in this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195
>CAMERA Reference Proteins (P)   
This data set contains non-redundant proteins from publicly available resources. Sequences less than 10 amino acids are also excluded from this set. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Human Proteins (P)   
This data set contains non-redundant human proteins of from publicly available resources. Peptide sequences that are less than 10 amino acids are excluded from this set. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Fungal Nucleotide Sequences (N)  
This data set contains non-redundant nucleotide sequences of fungi from publicly available resources. Sequences less than 50 bases are excluded from this set. Environmental samples are also excluded unless they are from the NCBI RefSeq database. If two sequences have the same taxon ID and they can be aligned with 100% identity, the shorter sequence is treated as a redundant sequence, and it is eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Reference Nucleotide Sequences (N)   
This data set contains non-redundant nucleotide sequences from publicly available resources. Sequences less than 50 bases are also excluded from this set. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Human Nucleotide Sequences (N)   
This data set contains non-redundant human nucleotide sequences from publicly available resources. Sequences less than 50 bases are excluded from this set. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Prokaryotic Nucleotide Sequences (N) 
This data set contains non-redundant nucleotide sequences of bacteria and archaea from publicly available resources. Sequences less than 50 bases are excluded from this set. Environmental samples are also excluded unless they are from the NCBI RefSeq database. If two sequences have the same taxon ID and they can be aligned with 100% identity, the shorter sequence is treated as a redundant sequence, and it is eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Viral Nucleotide Sequences (N)   
This data set contains non-redundant nucleotide sequences of viruses and viroids from publicly available resources. Sequences less than 50 bases are excluded from this set. Environmental samples are also excluded unless they are from the NCBI RefSeq database. If two sequences have the same taxon ID and they can be aligned with 100% identity, the shorter sequence is treated as a redundant sequence, and it is eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Fungal Proteins (P)  
This data set contains non-redundant protein sequences of fungi from publicly available resources. Peptide sequences less than 10 amino acids are excluded from this set. Environmental samples are also excluded unless they are from the NCBI RefSeq database. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Viral Proteins (P)   
This data set contains non-redundant protein sequences of viruses and viroids from publicly available resources. Peptide sequences less than 10 amino acids are excluded from this set. Environmental samples are also excluded unless they are from the NCBI RefSeq database. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195  
>CAMERA Prokaryotic Proteins (P) 
This data set contains non-redundant proteins of bacteria and archaea from publicly available resources. Peptide sequences less than 10 amino acids are excluded from this set. Environmental samples are also excluded unless they are from the NCBI RefSeq database. Shorter sequences that can be aligned with a longer sequence with the same taxon ID and 100% identity are treated as redundant sequences, and they are eliminated from this data set. 
Database updated on 2013-05-17 from NCBI Refseq release 59 and Genbank release 195

