#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use IMicrobe::DB;
use Pod::Usage;
use Readonly;
use Text::RecordParser;

Readonly my $MAPPING_FILE => '/usr/local/imicrobe/lib/docs/mapping_files/'
    . 'sample_metadata_fields.csv';

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

    reduce();

    say "Done.";
}

# --------------------------------------------------
sub reduce {
    my $p       = Text::RecordParser->new($MAPPING_FILE);
    my $map     = $p->fetchall_hashref('imicrobe');
    my $db      = IMicrobe::DB->new;
    my $schema  = $db->schema;
    my $Samples = $schema->resultset('Sample');
    my $i       = 0;

    while (my $Sample = $Samples->next) {
        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;
        for my $fld (keys %$map) {
            next unless $fld;

            my $val = trim($Sample->$fld());

            next if $val eq '';

            my $mixs_term = $map->{$fld}{'mixs_term'}    or next;
            my $mixs_cat  = $map->{$fld}{'category'}     || '';
            my $mixs_pkg  = $map->{$fld}{'mixs_package'} || '';

            next if $mixs_term =~ /[?"|]/; # questionable assignments
            next if $mixs_cat  =~ /[?]/;

            my ($SampleAttrType) 
                = $schema->resultset('SampleAttrType')->find_or_create({
                    type     => $mixs_term,
                    category => ucfirst $mixs_cat,
                });

            my ($SampleAttr) =
                $schema->resultset('SampleAttr')->find_or_create({
                    sample_id           => $Sample->id,
                    sample_attr_type_id => $SampleAttrType->id,
                    attr_value          => $val
                });

            printf "Moved %s (%s) => %s\n", 
                $fld, $val, $SampleAttrType->type;
        }
    }
}

# --------------------------------------------------
sub trim {
    my $s = shift // '';
    $s =~ s/^\s*|\s*$//g;
    return $s;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

reduce.pl - a script

=head1 SYNOPSIS

  reduce.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
