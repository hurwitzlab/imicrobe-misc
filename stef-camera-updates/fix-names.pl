#!/usr/bin/env perl

#                  sample: MMETSP0004_2
#             single_name: --
#           combined_name: Ochromonas-sp-CCMP1393
#                      pi: David Caron
#    lib_from_pcr_product: --
#          final organism:
#            final strain:
#                   notes:

use common::sense;
use autodie;
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser;

main();

# --------------------------------------------------
sub main {
    my ($help, $man_page);
    GetOptions(
        'help' => \$help,
        'man'  => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    my $p      = Text::RecordParser->new('data.csv');
    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;

    my $i;
    while (my $rec = $p->fetchrow_hashref) {
        my $sample_name = $rec->{'sample'} or next;
        my $Sample;

        for my $fld (qw[mmetsp_id sample_name]) {
            for my $name ($sample_name, "${sample_name}C") {
                ($Sample) = $schema->resultset('Sample')->search({
                    $fld => $name
                });

                last if $Sample;
            }
            last if $Sample;
        }

        if (!$Sample) {
            say "Can't find sample '$sample_name'";
            next;
        }

        printf "%5d: %s (%s)\n", 
            ++$i, $Sample->sample_name, $Sample->id;

        if ($Sample->sample_name ne $sample_name) {
            printf "      => %s\n", $sample_name;
#            $Sample->sample_name($sample_name);
#            $Sample->update;
        }
    }

    say "Done.";
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

fix-names.pl - a script

=head1 SYNOPSIS

  fix-names.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Charles Kenneth Youensclark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
