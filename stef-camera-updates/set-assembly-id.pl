#!/usr/bin/env perl

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
    my $Samples = $schema->resultset('Sample');

    my $i;
    while (my $rec = $p->fetchrow_hashref) {
        my $sample_name = $rec->{'sample'} or next;
        my ($Sample)    = $schema->resultset('Sample')->search({
            sample_name => $sample_name
        });

        if (!$Sample) {
            say STDERR "Can't find sample '$sample_name'";
            next;
        }

        my $asm_name = $rec->{'single_name'} eq '--' 
            ? $rec->{'sample'}
            : $rec->{'single_name'}
        ;

        printf "%5d: %s (%s) => %s\n", 
            ++$i, $Sample->sample_name, $Sample->id, $asm_name;

        my ($Assembly) = $schema->resultset('Assembly')->search({
            assembly_name => $asm_name
        });

        if (!$Assembly) {
            say STDERR "Can't find assembly '$asm_name'";
            next;
        }

        $Sample->assembly_id($Assembly->id);
        $Sample->update;

#        if ($Assembly->assembly_name ne $asm_name) {
#            printf "     Assembly '%s -> '%s'\n", 
#                $Assembly->assembly_name, $asm_name;
#
#            unless ($Assembly->description =~ /\S+/) {
#                $Assembly->description($Assembly->assembly_name);
#            }
#
#            $Assembly->assembly_name($asm_name);
#            $Assembly->update;
#        }
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
