#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use Pod::Usage;
use Readonly;
use IMicrobe::DB;
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

    #my $file = shift or pod2usage("No input file");
    my $file   = '/home/kyclark/work/imicrobe-lib/docs/mapping_files/'
               . 'CameraMetadata_ENVO_working_copy.csv';
    my $db     = IMicrobe::DB->new;
    my $dbh    = $db->dbh;
    my $schema = $db->schema;
    my $p      = Text::RecordParser->new($file);

    # ************ Record 1 ************
    #                   SAMPLE_ACC: ALVINELLA_SMPL_20041130
    #           SAMPLE_DESCRIPTION:
    #                  DESCRIPTION:
    #             SITE_DESCRIPTION: saltwater manmade
    #                       REGION: Arizona
    #                 HABITAT_NAME: saline water
    #                  biome_label: anthropogenic terrestrial biome
    #                     biome_id: ENVO:01000219
    # environmental_material_label: saline water
    #    environmental_material_id: ENVO:00002010
    #  environmental_feature_label: anthropogenic abiotic mesoscopic feature
    #     environmental_feature_id: ENVO:00003075
    #            suggest new terms:

    my @ontology_flds = (
        { acc => 'biome_id', label => 'biome_label' },
        {
            acc   => 'environmental_material_id',
            label => 'environmental_material_label'
        },
        {
            acc   => 'environmental_feature_id',
            label => 'environmental_feature_label'
        },
    );

    # Using schema
    my $i = 0;
#    SAMPLE:
#    for my $rec ($p->fetchrow_hashref) {
#        my $sample_acc = $rec->{'SAMPLE_ACC'} or next;
#        # call "search" in a list context, not scalar! here be dragons!
#        my ($Sample)   = $schema->resultset('Sample')->search({
#            sample_acc => $sample_acc
#        });
#
#        if (!$Sample) {
#            print "Cannot find sample '$sample_acc'\n";
#            next SAMPLE;
#        }
#
#        printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id;
#
#        OFLD:
#        for my $fld (@ontology_flds) {
#            my $acc_name   = $fld->{'acc'};
#            my $label_name = $fld->{'label'};
#            my $acc_val    = $rec->{ $acc_name }   or next OFLD;
#            my $label_val  = $rec->{ $label_name } || '';
#
#            my ($Ontology) = $schema->resulset('Ontology')->find_or_create({
#                ontology_acc => $acc_val,
#                label        => $label_val,
#            });
#
#            my ($S2O) = $schema->resulset('SampleToOntology')->find_or_create({
#                sample_id   => $Sample->id,
#                ontology_id => $Ontology->id,
#            });
#        }
#
#        last;
#    }

    # Using DBH
    $i = 0;
    while (my $rec =$p->fetchrow_hashref) {
        my $sample_acc = $rec->{'SAMPLE_ACC'} or next;
        my $sample_id = $dbh->selectrow_array(
            'select sample_id from sample where sample_acc=?', {},
            $sample_acc
        ) or next;

        printf "%5d: %s (%s)\n", ++$i, $sample_acc, $sample_id;

        OFLD:
        for my $fld (@ontology_flds) {
            my $acc_name   = $fld->{'acc'};
            my $label_name = $fld->{'label'};
            my $acc_val    = $rec->{ $acc_name }   or next OFLD;
            my $label_val  = $rec->{ $label_name } || '';
            my $ontology_id = get_ontology_id($dbh, $acc_val, $label_val);
            my $s2o_id      = get_s2o_id($dbh, $sample_id, $ontology_id);
        }
    }
}

# --------------------------------------------------
sub get_s2o_id {
    my ($dbh, $sample_id, $ontology_id) = @_;

    my $s2o_id = $dbh->selectrow_array(
        q[
            select sample_to_ontology_id 
            from   sample_to_ontology 
            where  sample_id=?
            and    ontology_id=?
        ], 
        {},
        ($sample_id, $ontology_id)
    );

    if (!$s2o_id) {
        $dbh->do(
            q[
                insert 
                into   sample_to_ontology (sample_id, ontology_id)
                values (?, ?) 
            ],
            {},
            ($sample_id, $ontology_id)
        );

        $s2o_id = $dbh->selectrow_array('select last_insert_id()');
    }

    return $s2o_id;
}

# --------------------------------------------------
sub get_ontology_id {
    my ($dbh, $acc_val, $label_val) = @_;
    my $ontology_id = $dbh->selectrow_array(
        'select ontology_id from ontology where ontology_acc=?', {},
        $acc_val
    );

    if (!$ontology_id) {
        $dbh->do(
            'insert into ontology (ontology_acc, label) values (?, ?)', {},
            ($acc_val, $label_val)
        );

        $ontology_id = $dbh->selectrow_array('select last_insert_id()');
    }

    return $ontology_id;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

add-ontology.pl - a script

=head1 SYNOPSIS

  add-ontology.pl 

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
