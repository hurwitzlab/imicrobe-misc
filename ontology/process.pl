
#!/usr/bin/env perl


use strict;
#use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use Pod::Usage;
use Readonly;
use IMicrobe::DB;
#use MyApp::Schema;
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
    my $samples = $schema->resultset(
        'Sample');
    
   while (my $sample = $samples->next){


   printf "ID : %d  \n" , $sample->id;

    
   } 

    
    
     }
    
   
   
   
    
  



__END__

# --------------------------------------------------

=pod

=head1 NAME

test.pl - a script

=head1 SYNOPSIS

  test.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

aish E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 aish

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
