#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use File::Basename qw'basename fileparse';
use File::Spec::Functions;
use IMicrobe::DB;

# >SargassoSea_READ_00109892 /accession=SargassoSea_READ_00109892 /length=271 /uaccno=FDJVGXF01C2RC4 /length=271 /sample_id=1308374654741644555 /sample_acc=SARGASSOSEA_SMPL_CONTROL /sample_name=SARGASSOSEA_SMPL_CONTROL /site_id_n=SARGASSOSEA_SITE_CONTROL
#
main(@ARGV);

sub main {
    my $schema = IMicrobe::DB->new->schema;
    my @files = @_ or die 'No files';
    my %loc;
    for my $file (<DATA>) {
        chomp $file;
        $loc{ basename($file) } = $file;
    }

    my $i;
    for my $file (@files) {
        my $base = basename($file);

        printf "\n%4d: %s\n", ++$i, $base;
        local $/ = '>';
        
        open my $fh, '<', $file;

        my %sample_acc;
        while (my $rec = <$fh>) {
            chomp $rec;
            next unless $rec;

            my ($hdr, @seq) = split /\n/, $rec;

            if ($hdr =~ m{/sample_acc=([^\s]+)}) {
                $sample_acc{ $1 }++;
            }
            last;
        }

        close $fh;

        my @sample_accs = sort keys %sample_acc;
        if (@sample_accs == 1) {
            my $sample_acc = shift @sample_accs;
            my ($Sample) = $schema->resultset('Sample')->search({
                sample_acc => $sample_acc
            });

            my $new_file = $sample_acc . '.fa';
            my $cur_read = $Sample->reads_file;
            my $old_loc  = $loc{ $base };
            my ($name, $old_path, $suffix) = fileparse($old_loc);
            my $new_path = catfile($old_path, $new_file);

            printf "%s (%s): %s -> %s\n", 
                $Sample->sample_name, 
                $Sample->id,
                $cur_read || "''", 
                $new_path;

            $Sample->reads_file($new_path);
            $Sample->update;

            printf STDERR "mv reads/%s reads/%s\n", $base, $new_file;
            printf STDERR "irm %s\n", $old_loc;
            printf STDERR "iput reads/%s %s\n", $new_file, $old_path;
        }
        else {
            say join "\n", "samples = ", (sort keys %sample_acc), '';
        }
    }

    say "Done.";
}

__DATA__
/iplant/home/shared/imicrobe/projects/13/samples/1309720343266460939.fa
/iplant/home/shared/imicrobe/projects/13/samples/1309720343400678667.fa
/iplant/home/shared/imicrobe/projects/13/samples/1309720343459398923.fa
/iplant/home/shared/imicrobe/projects/13/samples/1309720343513924875.fa
/iplant/home/shared/imicrobe/projects/13/samples/1309720343572645131.fa
/iplant/home/shared/imicrobe/projects/13/samples/1309720343627171083.fa
/iplant/home/shared/imicrobe/projects/19/samples/1314442544758654219.fa
/iplant/home/shared/imicrobe/projects/19/samples/1314442544788014347.fa
/iplant/home/shared/imicrobe/projects/19/samples/1314442544821568779.fa
/iplant/home/shared/imicrobe/projects/19/samples/1314442544850928907.fa
/iplant/home/shared/imicrobe/projects/20/samples/1362510248425817355.fa
/iplant/home/shared/imicrobe/projects/20/samples/1362510248463566091.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253394854839563.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253394909365515.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253394942919947.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253394989057291.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395022611723.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395056166155.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395089720587.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395123275019.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395156829451.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395190383883.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395219744011.fa
/iplant/home/shared/imicrobe/projects/27/samples/1317253395270075659.fa
/iplant/home/shared/imicrobe/projects/27/samples/1332544567492216075.fa
/iplant/home/shared/imicrobe/projects/27/samples/1332544567517381899.fa
/iplant/home/shared/imicrobe/projects/27/samples/1332544567550936331.fa
/iplant/home/shared/imicrobe/projects/27/samples/1332544567567713547.fa
/iplant/home/shared/imicrobe/projects/30/samples/1372769123590735115.fa
/iplant/home/shared/imicrobe/projects/30/samples/1372769123620095243.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931682612491.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931703584011.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931749721355.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931770692875.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931787470091.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931808441611.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931825218827.fa
/iplant/home/shared/imicrobe/projects/31/samples/1347433931841996043.fa
/iplant/home/shared/imicrobe/projects/32/samples/1373110013647652107.fa
/iplant/home/shared/imicrobe/projects/32/samples/1373110013668623627.fa
/iplant/home/shared/imicrobe/projects/32/samples/1373110013689595147.fa
/iplant/home/shared/imicrobe/projects/48/samples/1316602061755778357.fa
/iplant/home/shared/imicrobe/projects/48/samples/1316602061793527093.fa
/iplant/home/shared/imicrobe/projects/48/samples/1316602061831275829.fa
/iplant/home/shared/imicrobe/projects/48/samples/1316602061864830261.fa
/iplant/home/shared/imicrobe/projects/48/samples/1316602061898384693.fa
/iplant/home/shared/imicrobe/projects/48/samples/1316602061931939125.fa
/iplant/home/shared/imicrobe/projects/51/samples/1360420915145344267.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052830921458955.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052830942430475.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052830959207691.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052830980179211.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052830996956427.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052831017927947.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052831034705163.fa
/iplant/home/shared/imicrobe/projects/52/samples/1327052831055676683.fa
/iplant/home/shared/imicrobe/projects/54/samples/1378102155101078795.fa
/iplant/home/shared/imicrobe/projects/54/samples/1378102155189159179.fa
/iplant/home/shared/imicrobe/projects/54/samples/1378102155264656651.fa
/iplant/home/shared/imicrobe/projects/54/samples/1378102155340154123.fa
/iplant/home/shared/imicrobe/projects/54/samples/1378102155411457291.fa
/iplant/home/shared/imicrobe/projects/56/samples/1380619975747699979.fa
/iplant/home/shared/imicrobe/projects/56/samples/1380619975823197451.fa
/iplant/home/shared/imicrobe/projects/57/samples/1329873174451455243.fa
/iplant/home/shared/imicrobe/projects/57/samples/1329873174485009675.fa
/iplant/home/shared/imicrobe/projects/57/samples/1329873174501786891.fa
/iplant/home/shared/imicrobe/projects/57/samples/1329873174522758411.fa
/iplant/home/shared/imicrobe/projects/59/samples/1385714565320279307.fa
/iplant/home/shared/imicrobe/projects/59/samples/1385714565370610955.fa
/iplant/home/shared/imicrobe/projects/6/samples/1316500374978299189.fa
/iplant/home/shared/imicrobe/projects/6/samples/1316500375016047925.fa
/iplant/home/shared/imicrobe/projects/6/samples/1316500375053796661.fa
/iplant/home/shared/imicrobe/projects/6/samples/1316500375087351093.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944422294795.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944443266315.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944464237835.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944485209355.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944501986571.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944518763787.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944539735307.fa
/iplant/home/shared/imicrobe/projects/60/samples/1342599944556512523.fa
/iplant/home/shared/imicrobe/projects/61/samples/1308374654741644555.fa
/iplant/home/shared/imicrobe/projects/61/samples/1308374654821336331.fa
/iplant/home/shared/imicrobe/projects/62/samples/1335002427924940043.fa
/iplant/home/shared/imicrobe/projects/63/samples/1346220354825094411.fa
/iplant/home/shared/imicrobe/projects/63/samples/1346220354888008971.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078700336395.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078759056651.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078792611083.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078851331339.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078884885771.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078918440203.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078951994635.fa
/iplant/home/shared/imicrobe/projects/7/samples/1312147078981354763.fa
/iplant/home/shared/imicrobe/projects/71/samples/1388270474122757387.fa
/iplant/home/shared/imicrobe/projects/71/samples/1388270474156311819.fa
/iplant/home/shared/imicrobe/projects/71/samples/1388270474189866251.fa
/iplant/home/shared/imicrobe/projects/71/samples/1388270474219226379.fa
/iplant/home/shared/imicrobe/projects/71/samples/1388270474248586507.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989864960001291.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865048081675.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865102607627.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865157133579.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865211659531.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865266185483.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865337488651.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865392014603.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865442346251.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865492677899.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865559786763.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865605924107.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865652061451.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865698198795.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865740141835.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865819833611.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865865970955.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865924691211.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989865970828555.fa
/iplant/home/shared/imicrobe/projects/72/samples/1366989866008577291.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067410584843.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067481888011.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067540608267.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067595134219.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067649660171.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067704186123.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067771294987.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067825820939.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067876152587.fa
/iplant/home/shared/imicrobe/projects/72/samples/1370530067930678539.fa
/iplant/home/shared/imicrobe/projects/8/samples/1337529374911497483.fa
/iplant/home/shared/imicrobe/projects/8/samples/1337529374932469003.fa
/iplant/home/shared/imicrobe/projects/9/samples/1382448830435296523.fa
/iplant/home/shared/imicrobe/projects/9/samples/1382448830464656651.fa
/iplant/home/shared/imicrobe/projects/9/samples/1382448830481433867.fa
/iplant/home/shared/imicrobe/projects/9/samples/1382448830506599691.fa
