#!/usr/bin/env perl

use common::sense;
use autodie;
use Data::Dump 'dump';
use Getopt::Long;
use File::Spec::Functions 'catdir';
use IMicrobe::DB;
use Pod::Usage;
use Net::FTP;
use Readonly;

Readonly my $SITE => 'ftp.imicrobe.us';
Readonly my $PROJECTS_DIR => '/projects';

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

    my $db = IMicrobe::DB->new;
    my $schema = $db->schema;

    my $ftp = Net::FTP->new($SITE) or die "Failed to connect to '$SITE'\n";

    $ftp->login("anonymous", 'admin@imicrobe.us') or die "Failed to login\n";

    $ftp->cwd($PROJECTS_DIR) or die "Failed to cd to '$PROJECTS_DIR'\n";

    my @dirs = $ftp->ls or die "Failed to get directories\n";

    my $i;
    DIR:
    for my $dir (@dirs) {
        my ($Project) = $schema->resultset('Project')->find($dir);    

        if (!$Project) {
            say STDERR "Cannot find project id '$dir'\n";
            next DIR;
        }

        printf "%5d: %s (%s)\n", ++$i, $Project->project_name, $Project->id;

        my $Link = $schema->resultset('Ftp')->find_or_create({
            project_id => $Project->id,
            name       => 'Project folder',
            path       => catdir($PROJECTS_DIR, $dir),
        });
    }

    say "Done.";
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

make.pl - link projects to FTP

=head1 SYNOPSIS

  make.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Creates the proper links to the FTP site.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
