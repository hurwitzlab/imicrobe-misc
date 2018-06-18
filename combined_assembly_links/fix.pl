#!/usr/bin/env perl

use strict;
use feature 'say';
use File::Basename qw'dirname basename';
use File::Spec::Functions 'catdir';

my %seen;
while (my $file = <>) {
    chomp($file);
    (my $basename = basename($file)) =~ s/\.(pep|nt|cds)\.fa$//;
    my $dirname   = dirname($file);
    my $newdir    = catdir($dirname, $basename);

    unless ($seen{ $newdir }++) {
        say "imkdir $newdir";
    }

    say "imv $file $newdir";
}
