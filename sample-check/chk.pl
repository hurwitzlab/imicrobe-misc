#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use File::Basename 'basename';

main(@ARGV);

# --------------------------------------------------
sub main {
    my $file   = shift or die 'No file';
    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;
    my $i;

    open my $fh, '<', $file;

    for my $path (<$fh>) {
        chomp $path;

        printf "%5d: %s\n", ++$i, basename($path);

        my $project_id = project_id($path) or next;

        my ($Sample) = $schema->resultset('Sample')->search({
            project_id => $project_id,
            reads_file => $path,
        });

        if (!$Sample) {
            if ($Sample = sample($schema, $project_id, $path)) {
                printf STDERR "LINK %s => %s (%s)\n", 
                    $path,
                    $Sample->sample_name,
                    $Sample->id,
                ;
                $Sample->reads_file($path);
                $Sample->update;
            }
            else {
                say STDERR "NO SAMPLE FOR $path";
            }
        }
    }

    close $fh;

    say "Done.";
}

# --------------------------------------------------
sub project_id {
    my $path = shift or return;

    if ($path =~ m{/projects/(\d+)/}) {
        return $1; 
    }
    else {
        say STDERR "Can't extract project_id from '$path'";
        return;
    }
}

# --------------------------------------------------
sub sample {
    my ($schema, $project_id, $path) = @_;

    my $sample_name = basename($path, '.fa');

    my $Sample;
    for my $fld (qw[sample_name sample_acc]) {
        ($Sample) = $schema->resultset('Sample')->search({
            project_id => $project_id,
            $fld       => $sample_name,
        });
        last if $Sample;
    }

    return $Sample;
}
