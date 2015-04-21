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

    my $db      = IMicrobe::DB->new;
    my $schema  = $db->schema;
    my $ca_name = 'Extubocellulus-spinifer-CCMP396';

    my ($CA) = $schema->resultset('CombinedAssembly')->search({
        assembly_name => $ca_name
    });

    printf "%s -> %s\n", $ca_name, $CA ? 'found' : 'missing';
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
