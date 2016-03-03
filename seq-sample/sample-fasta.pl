#!/usr/bin/env perl

use common::sense;
use autodie;
use Bio::SeqIO;
use Data::Dump 'dump';
use File::Basename qw'dirname basename';
use File::Spec::Functions 'catfile';
use File::Path 'make_path';
use Getopt::Long;
use Pod::Usage;
use Readonly;

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }; 

    @ARGV or pod2usage('Missing files');

    my $nsample = $args{'number'} || 500;
    my $out_dir = $args{'outdir'} || '';

    if ($nsample < 1) {
        pod2usage("Number ($nsample) must be positive.");
    }

    if ($out_dir && ! -d $out_dir) {
        make_path($out_dir);
    }

    my $fnum = 0;
    for my $file (@ARGV) {
        my $basename = basename($file);
        my $out_file = catfile($out_dir || dirname($file), $basename . '.sub');
        chomp(my $nseqs = `grep -e '^>' $file | wc -l`);

        my %take;
        while (scalar(%take) < $nsample) {
            $take{ int(rand($nseqs)) }++;
        }

        printf "%5d: %s (%s) => %s\n", ++$fnum, $basename, $nseqs, $out_file;

        my $in = Bio::SeqIO->new(
            -file   => $file,
            -format => 'Fasta', 
        );

        my $out= Bio::SeqIO->new( 
            -file   => ">$out_file",
            -format => 'Fasta', 
        );

        my ($i, $ntaken) = (0, 0);
        while (my $seq = $in->next_seq) {
            if (exists $take{ ++$i }) {
                $out->write_seq($seq);
                $ntaken++;
            }
            last if $ntaken == $nsample;
        }
        last;
    }
}

# --------------------------------------------------
sub get_args {
    my %args;

    GetOptions(
        \%args,
        'number:i',
        'outdir:s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

sample-fasta.pl - a script

=head1 SYNOPSIS

  sample-fasta.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2016 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
