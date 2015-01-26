#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use Readonly;

Readonly my $PROJECT_ID => 114;

main();

# --------------------------------------------------
sub main {
    my $db     = IMicrobe::DB->new;
    my $schema = $db->schema;
    my $i      = 0;

    for my $name (<DATA>) {
        chomp $name;
        my $Sample = sample($schema, $name) or next;

        my $lat = $Sample->latitude;
        my $lon = $Sample->longitude;

        printf "%5d: %s (%s) %s <=> %s\n", 
            ++$i,
            $Sample->sample_name,
            $Sample->id,
            $lat,
            $lon,
        ;

        $Sample->latitude($lon);
        $Sample->longitude($lat);
        $Sample->update;
    }

    say "Done.";
}

# --------------------------------------------------
sub sample {
    my $schema      = shift;
    my $sample_name = shift or return;
    my ($Sample)    = $schema->resultset('Sample')->search({
        project_id  => $PROJECT_ID,
        sample_name => $sample_name,
    });

    if (!$Sample) {
        say STDERR "Can't find $sample_name";
        return;
    }
    
    return $Sample;
}

__DATA__
GS682_0.1
GS682_0.8
GS682_3.0
GS683_0.1
GS683_0.8
GS683_3.0
GS684_0.1
GS684_0.8
GS684_3.0
GS685_0.1
GS685_0.8
GS685_3.0
GS686_0.1
GS686_0.8
GS686_3.0
GS687_0.1
GS687_0.8
GS687_3.0
GS688_0.1
GS688_0.8
GS688_3.0
GS689_0.1
GS673_0.1
GS673_0.8
GS673_3.0
GS674_0.1
GS674_0.8
GS674_3.0
GS677_0.1
GS677_0.8
GS677_3.0
GS678_0.1
GS678_0.8
GS678_3.0
GS679_0.1
GS679_0.8
GS679_3.0
GS681_0.1
GS681_0.8
GS681_3.0
GS689_0.8
GS689_3.0
GS694_0.1
GS694_0.8
GS694_3.0
GS695_0.1
GS695_0.8
GS695_3.0
