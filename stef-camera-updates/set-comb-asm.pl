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
        (my $ca_name = $rec->{'combined_name'}) =~ s/_/ /g;

        next if $ca_name eq 'NA';

        my $sample_name = $rec->{'sample'} or next;
        my ($Sample)    = $schema->resultset('Sample')->search({
            sample_name => $sample_name
        });

        if (!$Sample) {
            say STDERR "Can't find sample '$sample_name'";
            next;
        }

        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;

        if (my $CA = $Sample->combined_assembly) {
            if ($CA->assembly_name ne $ca_name) {
                printf "     %s => %s\n", $CA->assembly_name, $ca_name;
#                $CA->assembly_name($ca_name);
#                $CA->update;
            }
        }
        else {
            my ($CA) = $schema->resultset('CombinedAssembly')->search({
                assembly_name => $ca_name
            });

            if ($CA) {
                printf STDERR "need to link ca '%s' (%s) to %s\n",
                    $CA->assembly_name, $CA->id, $Sample->sample_name;
#                $Sample->combined_assembly_id($CA->id);
#                $Sample->update;
            }
            else {
                say STDERR "need to create '$ca_name' for '$sample_name'";
            }
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
