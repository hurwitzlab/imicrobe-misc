#!/usr/bin/env perl

use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;

my $db = IMicrobe::DB->new->dbh;
my $url = "http://mirrors.iplantcollaborative.org/browse/iplant/home/shared/imicrobe/camera/camera_mmetsp_ncgr/transcriptomes/";
for my $file (<DATA>) {
    chomp($file);

    my ($asm_name, $type, $ext) = split /\./, $file;

    my $asm_id = $db->selectrow_array(
        'select assembly_id from assembly where organism=?', {},
        $asm_name
    );

    if ($asm_id) {
        say "$file => $asm_name [$type] ($asm_id)";
        my $field = $type . '_file';
        $db->do(
            "update assembly set $field=? where assembly_id=?", {},
            ($url . $file, $asm_id)
        );
    }
    else {
        say "Can't find '$asm_name'";
        next;
    }
}

say "Done.";

__DATA__
MMETSP0004.cds.fa
MMETSP0004.nt.fa
MMETSP0004.pep.fa
MMETSP0005.cds.fa
MMETSP0005.nt.fa
MMETSP0005.pep.fa
MMETSP0006.cds.fa
MMETSP0006.nt.fa
MMETSP0006.pep.fa
MMETSP0007.cds.fa
MMETSP0007.nt.fa
MMETSP0007.pep.fa
MMETSP0008.cds.fa
MMETSP0008.nt.fa
MMETSP0008.pep.fa
MMETSP0009.cds.fa
MMETSP0009.nt.fa
MMETSP0009.pep.fa
MMETSP0010.cds.fa
MMETSP0010.nt.fa
MMETSP0010.pep.fa
MMETSP0011.cds.fa
MMETSP0011.nt.fa
MMETSP0011.pep.fa
MMETSP0013.cds.fa
MMETSP0013.nt.fa
MMETSP0013.pep.fa
MMETSP0014.cds.fa
MMETSP0014.nt.fa
MMETSP0014.pep.fa
MMETSP0015.cds.fa
MMETSP0015.nt.fa
MMETSP0015.pep.fa
MMETSP0017.cds.fa
MMETSP0017.nt.fa
MMETSP0017.pep.fa
MMETSP0018.cds.fa
MMETSP0018.nt.fa
MMETSP0018.pep.fa
MMETSP0019.cds.fa
MMETSP0019.nt.fa
MMETSP0019.pep.fa
MMETSP0020.cds.fa
MMETSP0020.nt.fa
MMETSP0020.pep.fa
MMETSP0027.cds.fa
MMETSP0027.nt.fa
MMETSP0027.pep.fa
MMETSP0029.cds.fa
MMETSP0029.nt.fa
MMETSP0029.pep.fa
MMETSP0030.cds.fa
MMETSP0030.nt.fa
MMETSP0030.pep.fa
MMETSP0031.cds.fa
MMETSP0031.nt.fa
MMETSP0031.pep.fa
MMETSP0033.cds.fa
MMETSP0033.nt.fa
MMETSP0033.pep.fa
MMETSP0034.cds.fa
MMETSP0034.nt.fa
MMETSP0034.pep.fa
MMETSP0038.cds.fa
MMETSP0038.nt.fa
MMETSP0038.pep.fa
MMETSP0039.cds.fa
MMETSP0039.nt.fa
MMETSP0039.pep.fa
MMETSP0040.cds.fa
MMETSP0040.nt.fa
MMETSP0040.pep.fa
MMETSP0041.cds.fa
MMETSP0041.nt.fa
MMETSP0041.pep.fa
MMETSP0042.cds.fa
MMETSP0042.nt.fa
MMETSP0042.pep.fa
MMETSP0043.cds.fa
MMETSP0043.nt.fa
MMETSP0043.pep.fa
MMETSP0044.cds.fa
MMETSP0044.nt.fa
MMETSP0044.pep.fa
MMETSP0045.cds.fa
MMETSP0045.nt.fa
MMETSP0045.pep.fa
MMETSP0046.cds.fa
MMETSP0046.nt.fa
MMETSP0046.pep.fa
MMETSP0047.cds.fa
MMETSP0047.nt.fa
MMETSP0047.pep.fa
MMETSP0052.cds.fa
MMETSP0052.nt.fa
MMETSP0052.pep.fa
MMETSP0053.cds.fa
MMETSP0053.nt.fa
MMETSP0053.pep.fa
MMETSP0055.cds.fa
MMETSP0055.nt.fa
MMETSP0055.pep.fa
MMETSP0056.cds.fa
MMETSP0056.nt.fa
MMETSP0056.pep.fa
MMETSP0057.cds.fa
MMETSP0057.nt.fa
MMETSP0057.pep.fa
MMETSP0058.cds.fa
MMETSP0058.nt.fa
MMETSP0058.pep.fa
MMETSP0059.cds.fa
MMETSP0059.nt.fa
MMETSP0059.pep.fa
MMETSP0063.cds.fa
MMETSP0063.nt.fa
MMETSP0063.pep.fa
MMETSP0086.cds.fa
MMETSP0086.nt.fa
MMETSP0086.pep.fa
MMETSP0087.cds.fa
MMETSP0087.nt.fa
MMETSP0087.pep.fa
MMETSP0088.cds.fa
MMETSP0088.nt.fa
MMETSP0088.pep.fa
MMETSP0090.cds.fa
MMETSP0090.nt.fa
MMETSP0090.pep.fa
MMETSP0091.cds.fa
MMETSP0091.nt.fa
MMETSP0091.pep.fa
MMETSP0092.cds.fa
MMETSP0092.nt.fa
MMETSP0092.pep.fa
MMETSP0093.cds.fa
MMETSP0093.nt.fa
MMETSP0093.pep.fa
MMETSP0095.cds.fa
MMETSP0095.nt.fa
MMETSP0095.pep.fa
MMETSP0096.cds.fa
MMETSP0096.nt.fa
MMETSP0096.pep.fa
MMETSP0097.cds.fa
MMETSP0097.nt.fa
MMETSP0097.pep.fa
MMETSP0098.cds.fa
MMETSP0098.nt.fa
MMETSP0098.pep.fa
MMETSP0099.cds.fa
MMETSP0099.nt.fa
MMETSP0099.pep.fa
MMETSP0100.cds.fa
MMETSP0100.nt.fa
MMETSP0100.pep.fa
MMETSP0101.cds.fa
MMETSP0101.nt.fa
MMETSP0101.pep.fa
MMETSP0102.cds.fa
MMETSP0102.nt.fa
MMETSP0102.pep.fa
MMETSP0103.cds.fa
MMETSP0103.nt.fa
MMETSP0103.pep.fa
MMETSP0104.cds.fa
MMETSP0104.nt.fa
MMETSP0104.pep.fa
MMETSP0105.cds.fa
MMETSP0105.nt.fa
MMETSP0105.pep.fa
MMETSP0106.cds.fa
MMETSP0106.nt.fa
MMETSP0106.pep.fa
MMETSP0107.cds.fa
MMETSP0107.nt.fa
MMETSP0107.pep.fa
MMETSP0108.cds.fa
MMETSP0108.nt.fa
MMETSP0108.pep.fa
MMETSP0109.cds.fa
MMETSP0109.nt.fa
MMETSP0109.pep.fa
MMETSP0110.cds.fa
MMETSP0110.nt.fa
MMETSP0110.pep.fa
MMETSP0111.cds.fa
MMETSP0111.nt.fa
MMETSP0111.pep.fa
MMETSP0112.cds.fa
MMETSP0112.nt.fa
MMETSP0112.pep.fa
MMETSP0113.cds.fa
MMETSP0113.nt.fa
MMETSP0113.pep.fa
MMETSP0114.cds.fa
MMETSP0114.nt.fa
MMETSP0114.pep.fa
MMETSP0115.cds.fa
MMETSP0115.nt.fa
MMETSP0115.pep.fa
MMETSP0116.cds.fa
MMETSP0116.nt.fa
MMETSP0116.pep.fa
MMETSP0117.cds.fa
MMETSP0117.nt.fa
MMETSP0117.pep.fa
MMETSP0118.cds.fa
MMETSP0118.nt.fa
MMETSP0118.pep.fa
MMETSP0119.cds.fa
MMETSP0119.nt.fa
MMETSP0119.pep.fa
MMETSP0120.cds.fa
MMETSP0120.nt.fa
MMETSP0120.pep.fa
MMETSP0121.cds.fa
MMETSP0121.nt.fa
MMETSP0121.pep.fa
MMETSP0123.cds.fa
MMETSP0123.nt.fa
MMETSP0123.pep.fa
MMETSP0125.cds.fa
MMETSP0125.nt.fa
MMETSP0125.pep.fa
MMETSP0126.cds.fa
MMETSP0126.nt.fa
MMETSP0126.pep.fa
MMETSP0127.cds.fa
MMETSP0127.nt.fa
MMETSP0127.pep.fa
MMETSP0132.cds.fa
MMETSP0132.nt.fa
MMETSP0132.pep.fa
MMETSP0139.cds.fa
MMETSP0139.nt.fa
MMETSP0139.pep.fa
MMETSP0140.cds.fa
MMETSP0140.nt.fa
MMETSP0140.pep.fa
MMETSP0141.cds.fa
MMETSP0141.nt.fa
MMETSP0141.pep.fa
MMETSP0142.cds.fa
MMETSP0142.nt.fa
MMETSP0142.pep.fa
MMETSP0143.cds.fa
MMETSP0143.nt.fa
MMETSP0143.pep.fa
MMETSP0145.cds.fa
MMETSP0145.nt.fa
MMETSP0145.pep.fa
MMETSP0146.cds.fa
MMETSP0146.nt.fa
MMETSP0146.pep.fa
MMETSP0147.cds.fa
MMETSP0147.nt.fa
MMETSP0147.pep.fa
MMETSP0149.cds.fa
MMETSP0149.nt.fa
MMETSP0149.pep.fa
MMETSP0150.cds.fa
MMETSP0150.nt.fa
MMETSP0150.pep.fa
MMETSP0151.cds.fa
MMETSP0151.nt.fa
MMETSP0151.pep.fa
MMETSP0152.cds.fa
MMETSP0152.nt.fa
MMETSP0152.pep.fa
MMETSP0154.cds.fa
MMETSP0154.nt.fa
MMETSP0154.pep.fa
MMETSP0156.cds.fa
MMETSP0156.nt.fa
MMETSP0156.pep.fa
MMETSP0158.cds.fa
MMETSP0158.nt.fa
MMETSP0158.pep.fa
MMETSP0160.cds.fa
MMETSP0160.nt.fa
MMETSP0160.pep.fa
MMETSP0161.cds.fa
MMETSP0161.nt.fa
MMETSP0161.pep.fa
MMETSP0164.cds.fa
MMETSP0164.nt.fa
MMETSP0164.pep.fa
MMETSP0166.cds.fa
MMETSP0166.nt.fa
MMETSP0166.pep.fa
MMETSP0167.cds.fa
MMETSP0167.nt.fa
MMETSP0167.pep.fa
MMETSP0168.cds.fa
MMETSP0168.nt.fa
MMETSP0168.pep.fa
MMETSP0169.cds.fa
MMETSP0169.nt.fa
MMETSP0169.pep.fa
MMETSP0171.cds.fa
MMETSP0171.nt.fa
MMETSP0171.pep.fa
MMETSP0173.cds.fa
MMETSP0173.nt.fa
MMETSP0173.pep.fa
MMETSP0174.cds.fa
MMETSP0174.nt.fa
MMETSP0174.pep.fa
MMETSP0176.cds.fa
MMETSP0176.nt.fa
MMETSP0176.pep.fa
MMETSP0186.cds.fa
MMETSP0186.nt.fa
MMETSP0186.pep.fa
MMETSP0190.cds.fa
MMETSP0190.nt.fa
MMETSP0190.pep.fa
MMETSP0191.cds.fa
MMETSP0191.nt.fa
MMETSP0191.pep.fa
MMETSP0196.cds.fa
MMETSP0196.nt.fa
MMETSP0196.pep.fa
MMETSP0198.cds.fa
MMETSP0198.nt.fa
MMETSP0198.pep.fa
MMETSP0199.cds.fa
MMETSP0199.nt.fa
MMETSP0199.pep.fa
MMETSP0200.cds.fa
MMETSP0200.nt.fa
MMETSP0200.pep.fa
MMETSP0201.cds.fa
MMETSP0201.nt.fa
MMETSP0201.pep.fa
MMETSP0202.cds.fa
MMETSP0202.nt.fa
MMETSP0202.pep.fa
MMETSP0205.cds.fa
MMETSP0205.nt.fa
MMETSP0205.pep.fa
MMETSP0206.cds.fa
MMETSP0206.nt.fa
MMETSP0206.pep.fa
MMETSP0208.cds.fa
MMETSP0208.nt.fa
MMETSP0208.pep.fa
MMETSP0209.cds.fa
MMETSP0209.nt.fa
MMETSP0209.pep.fa
MMETSP0210.cds.fa
MMETSP0210.nt.fa
MMETSP0210.pep.fa
MMETSP0211.cds.fa
MMETSP0211.nt.fa
MMETSP0211.pep.fa
MMETSP0213.cds.fa
MMETSP0213.nt.fa
MMETSP0213.pep.fa
MMETSP0216.cds.fa
MMETSP0216.nt.fa
MMETSP0216.pep.fa
MMETSP0223.cds.fa
MMETSP0223.nt.fa
MMETSP0223.pep.fa
MMETSP0224.cds.fa
MMETSP0224.nt.fa
MMETSP0224.pep.fa
MMETSP0225.cds.fa
MMETSP0225.nt.fa
MMETSP0225.pep.fa
MMETSP0227.cds.fa
MMETSP0227.nt.fa
MMETSP0227.pep.fa
MMETSP0228.cds.fa
MMETSP0228.nt.fa
MMETSP0228.pep.fa
MMETSP0229.cds.fa
MMETSP0229.nt.fa
MMETSP0229.pep.fa
MMETSP0232.cds.fa
MMETSP0232.nt.fa
MMETSP0232.pep.fa
MMETSP0233.cds.fa
MMETSP0233.nt.fa
MMETSP0233.pep.fa
MMETSP0234.cds.fa
MMETSP0234.nt.fa
MMETSP0234.pep.fa
MMETSP0235.cds.fa
MMETSP0235.nt.fa
MMETSP0235.pep.fa
MMETSP0251.cds.fa
MMETSP0251.nt.fa
MMETSP0251.pep.fa
MMETSP0252.cds.fa
MMETSP0252.nt.fa
MMETSP0252.pep.fa
MMETSP0253.cds.fa
MMETSP0253.nt.fa
MMETSP0253.pep.fa
MMETSP0258.cds.fa
MMETSP0258.nt.fa
MMETSP0258.pep.fa
MMETSP0259.cds.fa
MMETSP0259.nt.fa
MMETSP0259.pep.fa
MMETSP0267.cds.fa
MMETSP0267.nt.fa
MMETSP0267.pep.fa
MMETSP0268.cds.fa
MMETSP0268.nt.fa
MMETSP0268.pep.fa
MMETSP0269.cds.fa
MMETSP0269.nt.fa
MMETSP0269.pep.fa
MMETSP0270.cds.fa
MMETSP0270.nt.fa
MMETSP0270.pep.fa
MMETSP0271.cds.fa
MMETSP0271.nt.fa
MMETSP0271.pep.fa
MMETSP0272.cds.fa
MMETSP0272.nt.fa
MMETSP0272.pep.fa
MMETSP0286.cds.fa
MMETSP0286.nt.fa
MMETSP0286.pep.fa
MMETSP0287.cds.fa
MMETSP0287.nt.fa
MMETSP0287.pep.fa
MMETSP0288.cds.fa
MMETSP0288.nt.fa
MMETSP0288.pep.fa
MMETSP0290.cds.fa
MMETSP0290.nt.fa
MMETSP0290.pep.fa
MMETSP0292.cds.fa
MMETSP0292.nt.fa
MMETSP0292.pep.fa
MMETSP0294.cds.fa
MMETSP0294.nt.fa
MMETSP0294.pep.fa
MMETSP0295.cds.fa
MMETSP0295.nt.fa
MMETSP0295.pep.fa
MMETSP0296.cds.fa
MMETSP0296.nt.fa
MMETSP0296.pep.fa
MMETSP0308.cds.fa
MMETSP0308.nt.fa
MMETSP0308.pep.fa
MMETSP0312.cds.fa
MMETSP0312.nt.fa
MMETSP0312.pep.fa
MMETSP0313.cds.fa
MMETSP0313.nt.fa
MMETSP0313.pep.fa
MMETSP0314.cds.fa
MMETSP0314.nt.fa
MMETSP0314.pep.fa
MMETSP0315.cds.fa
MMETSP0315.nt.fa
MMETSP0315.pep.fa
MMETSP0316.cds.fa
MMETSP0316.nt.fa
MMETSP0316.pep.fa
MMETSP0317.cds.fa
MMETSP0317.nt.fa
MMETSP0317.pep.fa
MMETSP0318.cds.fa
MMETSP0318.nt.fa
MMETSP0318.pep.fa
MMETSP0319.cds.fa
MMETSP0319.nt.fa
MMETSP0319.pep.fa
MMETSP0320.cds.fa
MMETSP0320.nt.fa
MMETSP0320.pep.fa
MMETSP0321.cds.fa
MMETSP0321.nt.fa
MMETSP0321.pep.fa
MMETSP0322.cds.fa
MMETSP0322.nt.fa
MMETSP0322.pep.fa
MMETSP0323.cds.fa
MMETSP0323.nt.fa
MMETSP0323.pep.fa
MMETSP0324.cds.fa
MMETSP0324.nt.fa
MMETSP0324.pep.fa
MMETSP0325.cds.fa
MMETSP0325.nt.fa
MMETSP0325.pep.fa
MMETSP0326.cds.fa
MMETSP0326.nt.fa
MMETSP0326.pep.fa
MMETSP0327.cds.fa
MMETSP0327.nt.fa
