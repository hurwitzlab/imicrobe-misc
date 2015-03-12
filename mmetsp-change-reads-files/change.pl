#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use File::Basename 'basename';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;

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
    my $Project = $schema->resultset('Project')->find(104);
    my $Samples = $Project->samples;

    my ($AssemblyFileType) = $schema->resultset('SampleFileType')->search({
        type => 'Assembly'
    }) or die "Can't find assembly";

    my $i;
    while (my $Sample = $Samples->next) {
        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;
        for my $File ($Sample->sample_files) {
            if ($File->sample_file_type->type eq 'Reads') {
                printf "%25s => %s\n", basename($File->file), $AssemblyFileType->id;
                $File->sample_file_type_id($AssemblyFileType->id);
                $File->update;
            }
        }
    }

    say "Done.";
}


__END__

# --------------------------------------------------

=pod

=head1 NAME

change.pl - a script

=head1 SYNOPSIS

  change.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

kyclark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
