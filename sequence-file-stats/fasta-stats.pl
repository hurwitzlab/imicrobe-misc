#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use Data::Dump 'dump';
use File::Find::Rule;
use File::Spec::Functions qw'catfile catdir';
use File::Basename qw'dirname basename';
use Number::Bytes::Human 'format_bytes';
use IO::Zlib;

my $dir = shift || '/RepositoryPool00/PublicFTP/projects';

say STDERR "Searching dir '$dir'";

my @files 
    = File::Find::Rule->file()->name(qr/\.(fa|fna|fasta)(.gz)?$/)->in($dir);

say STDERR "Found ", scalar(@files);

my $fnum = 0;
for my $file (@files) {
    (my $basename = basename($file)) =~ s/\.gz$//;

    my $stats_file = catfile(dirname($file), $basename . '.stats.tab');
    next if -e $stats_file;

    printf STDERR "%6d: %s\n", ++$fnum, $basename;

    my $fh;
    if ($file =~ /\.gz$/) {
        $fh = IO::Zlib->new($file, "rb"); 
    }
    else {
        open $fh, '<', $file;
    }

    my $next_seq = sub {
        my $buffer = '';
        while (my $line = <$fh>) {
            chomp($line);
            if ($line =~ /^>/) {
                return $buffer if $buffer;
                $buffer = '';
            }
            else {
                $buffer .= $line;
            }
        }
        return $buffer;
    };

    my ($nseqs, $gc) = (0, 0);
    my %lengths;
    while (my $seq = $next_seq->()) {
        $nseqs++;
        my $l += length($seq);
        my @gc = ($seq =~ /[gc]/gi);
        $lengths{ $l }++;
        $gc += scalar(@gc);
    }

    my $total_bp = 0;
    while (my ($l, $n) = each %lengths) {
        $total_bp += $l * $n;
    }

    open my $out, '>', $stats_file;

    my ($project_id, $sample_id) = ('', '');

    if ($file =~ m{/projects/(\d+)/samples/(\d+)/}) {
        $project_id = $1;
        $sample_id  = $2;
    }

    say $out join "\n", 
        map { join "\t", @$_ }
        [ qw(file project_id sample_id num_seqs num_bp avg_len pct_gc) ],
        [ basename($file),
          $project_id,
          $sample_id,
          $nseqs, 
          format_bytes($total_bp),
          $nseqs    > 0 ? sprintf('%.2f', $total_bp / $nseqs)    : 0,
          $total_bp > 0 ? sprintf('%.2f', ($gc/$total_bp) * 100) : 0,
        ]
    ;

    close $out;
}

printf STDERR "Done, processed %s file%s\n", $fnum, $fnum == 1 ? '' : 's';
