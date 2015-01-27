#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use autodie;
use WWW::Mechanize;
use HTML::LinkExtractor;
use Data::Dump 'dump';

my $lx   = HTML::LinkExtractor->new;
my $www  = WWW::Mechanize->new;
my $link = 'http://camera.calit2.net/mmetsp/details.php?id=';

for my $sample (<DATA>) {
    chomp $sample;
    say $sample;

    my $res = $www->get($link . $sample);
    if ($res->is_success) {
        my $content = $res->decoded_content;
        $lx->parse(\$content);
        say join "\n", 
            grep { /^ftp/ } map { $_->{'href'} || () } @{ $lx->links };
    } 
}

__DATA__
MMETSP0982
MMETSP0503
MMETSP0168
MMETSP0784
MMETSP0017
MMETSP0018
MMETSP0004
MMETSP0005
MMETSP0006
MMETSP0007
MMETSP0008
MMETSP0009
MMETSP0010
MMETSP0011
MMETSP0013
MMETSP0014
MMETSP0015
MMETSP0034
MMETSP0041
MMETSP0042
MMETSP0043
MMETSP0038
MMETSP0039
MMETSP0040
MMETSP0027
MMETSP0029
MMETSP0030
MMETSP0031
MMETSP0033
MMETSP0019
MMETSP0020
MMETSP0058
MMETSP0059
MMETSP0063
MMETSP0086
MMETSP0044
MMETSP0045
MMETSP0046
MMETSP0052
MMETSP0095
MMETSP0096
MMETSP0103
MMETSP0104
MMETSP0107
MMETSP0108
MMETSP0105
MMETSP0106
MMETSP0097
MMETSP0098
MMETSP0099
MMETSP0100
MMETSP0101
MMETSP0102
MMETSP0087
MMETSP0093
MMETSP0117
MMETSP0118
MMETSP0121
MMETSP0123
MMETSP0119
MMETSP0120
MMETSP0109
MMETSP0110
MMETSP0111
MMETSP0112
MMETSP0113
MMETSP0114
MMETSP0115
MMETSP0116
MMETSP0126
MMETSP0127
MMETSP0139
MMETSP0142
MMETSP0143
MMETSP0145
MMETSP0140
MMETSP0141
MMETSP0132_2C
MMETSP0125
MMETSP0156
MMETSP0158
MMETSP0160
MMETSP0161
MMETSP0146
MMETSP0147
MMETSP0149
MMETSP0150
MMETSP0151
MMETSP0152
MMETSP0154
MMETSP0167
MMETSP0190
MMETSP0191
MMETSP0169
MMETSP0171
MMETSP0173
MMETSP0174
MMETSP0176
MMETSP0186
MMETSP0164
MMETSP0202
MMETSP0208
MMETSP0196C
MMETSP0198
MMETSP0199
MMETSP0200
MMETSP0201
MMETSP0211
MMETSP0213
MMETSP0224
MMETSP0225
MMETSP0228
MMETSP0229
MMETSP0227
MMETSP0216
MMETSP0209
MMETSP0210
MMETSP0259
MMETSP0267
MMETSP0270
MMETSP0271
MMETSP0268
MMETSP0269
MMETSP0232
MMETSP0233
MMETSP0234
MMETSP0235
MMETSP0251
MMETSP0252
MMETSP0253
MMETSP0258
MMETSP0287
MMETSP0316
MMETSP0317
MMETSP0320
MMETSP0321
MMETSP0318
MMETSP0319
MMETSP0292
MMETSP0294
MMETSP0295
MMETSP0296
MMETSP0272
MMETSP0347
MMETSP0359
MMETSP0360
MMETSP0361
MMETSP0322
MMETSP0323
MMETSP0325
MMETSP0326
MMETSP0327
MMETSP0328
MMETSP0329
MMETSP0370
MMETSP0371
MMETSP0382
MMETSP0398C
MMETSP0384
MMETSP0397
MMETSP0372
MMETSP0378
MMETSP0380
MMETSP0367
MMETSP0368
MMETSP0369
MMETSP0413
MMETSP0416
MMETSP0417
MMETSP0414
MMETSP0415
MMETSP0403
MMETSP0404
MMETSP0405
MMETSP0409
MMETSP0410
MMETSP0411
MMETSP0420
MMETSP0434
MMETSP0449
MMETSP0451_2C
MMETSP0468
MMETSP0469
MMETSP0470
MMETSP0463
MMETSP0467
MMETSP0436
MMETSP0437
MMETSP0439
MMETSP0447
MMETSP0448
MMETSP0418
MMETSP0419
MMETSP0959
MMETSP0975
MMETSP0976
MMETSP1002
MMETSP1005
MMETSP1032
MMETSP1033
MMETSP1034
MMETSP1035
MMETSP1036
MMETSP1037
MMETSP1038
MMETSP1039
MMETSP1040
MMETSP1041
MMETSP1042
MMETSP1043
MMETSP1047
MMETSP1048
MMETSP1049
MMETSP1050
MMETSP1052
MMETSP1054
MMETSP1055
MMETSP1057
MMETSP1058
MMETSP1059
MMETSP1060
MMETSP1075
MMETSP1080
MMETSP1115
MMETSP1116
MMETSP1117
MMETSP1061
MMETSP1062
MMETSP1063
MMETSP1086
MMETSP1064
MMETSP1066
MMETSP1067
MMETSP1089
MMETSP1095
MMETSP1122
MMETSP1123
MMETSP1068
MMETSP1070
MMETSP1096
MMETSP1097
MMETSP1124
MMETSP1125
MMETSP1126
MMETSP1071
MMETSP1100
MMETSP1127
MMETSP1128
MMETSP1129
MMETSP1074
MMETSP1130
MMETSP1131
MMETSP1132
MMETSP0944
MMETSP0945
MMETSP0946
MMETSP0960
MMETSP0977
MMETSP0983
MMETSP0984
MMETSP1006
MMETSP0947
MMETSP0948
MMETSP0961
MMETSP0985
MMETSP0986
MMETSP1007
MMETSP0949
MMETSP0950
MMETSP0962
MMETSP0987
MMETSP0988
MMETSP1008
MMETSP0954
MMETSP0963
MMETSP0989
MMETSP0990
MMETSP1009
MMETSP1010
MMETSP0955
MMETSP0964
MMETSP0991
MMETSP0992
MMETSP0993
MMETSP1013
MMETSP1015
MMETSP0956
MMETSP0965
MMETSP0970
MMETSP0994
MMETSP0995
MMETSP1016
MMETSP1017
MMETSP0957
MMETSP0971
MMETSP0972
MMETSP0996
MMETSP0997
MMETSP1018
MMETSP0958
MMETSP0973
MMETSP0974
MMETSP0998
MMETSP1001
MMETSP0648
MMETSP0725
MMETSP0726
MMETSP0727
MMETSP0815
MMETSP0816
MMETSP0817
MMETSP0888
MMETSP0889
MMETSP0890
MMETSP0891
MMETSP0733
MMETSP0734
MMETSP0735
MMETSP0892
MMETSP0893
MMETSP0894
MMETSP0895
MMETSP0896
MMETSP0897
MMETSP0736
MMETSP0737
MMETSP0738
MMETSP0898
MMETSP0899
MMETSP0900
MMETSP0901
MMETSP0902
MMETSP0903
MMETSP0904
MMETSP0905
MMETSP0739
MMETSP0740
MMETSP0744
MMETSP0906
MMETSP0907
MMETSP0908
MMETSP0909
MMETSP0914
MMETSP0924C
MMETSP0745
MMETSP0746
MMETSP0747
MMETSP0915
MMETSP0916
MMETSP0929
MMETSP0936
MMETSP0937
MMETSP0938
MMETSP0751
MMETSP0752
MMETSP0753
MMETSP0930
MMETSP0932
MMETSP0939
MMETSP0941
MMETSP0917
MMETSP0918
MMETSP0754
MMETSP0758
MMETSP0942
MMETSP0943
MMETSP0933
MMETSP0759
MMETSP0766
MMETSP0780
MMETSP0922C
MMETSP0471
MMETSP0472
MMETSP0649
MMETSP0661
MMETSP0785
MMETSP0786
MMETSP0789
MMETSP0818
MMETSP0819
MMETSP0820
MMETSP0484
MMETSP0689
MMETSP0794
MMETSP0795
MMETSP0850
MMETSP0491
MMETSP0796
MMETSP0797
MMETSP0798
MMETSP0851
MMETSP0852
MMETSP0527
MMETSP0799
MMETSP0800
MMETSP0802
MMETSP0853
MMETSP0878
MMETSP0879
MMETSP0528
MMETSP0562
MMETSP0705
MMETSP0803
MMETSP0804
MMETSP0806
MMETSP0880
MMETSP0881
MMETSP0563
MMETSP0573
MMETSP0706
MMETSP0707
MMETSP0708
MMETSP0807
MMETSP0809
MMETSP0810
MMETSP0882
MMETSP0883
MMETSP0574
MMETSP0578
MMETSP0713
MMETSP0716
MMETSP0717
MMETSP0811
MMETSP0812
MMETSP0884
MMETSP0885
MMETSP0593
MMETSP0718
MMETSP0719
MMETSP0724
MMETSP0814
MMETSP0886
MMETSP0887
MMETSP0595
MMETSP0603
MMETSP0604
MMETSP1163
MMETSP1164
MMETSP1165
MMETSP1318
MMETSP1319
MMETSP1320
MMETSP1347
MMETSP1167
MMETSP1321
MMETSP1322
MMETSP1323
MMETSP1348
MMETSP1136
MMETSP1137
MMETSP1138
MMETSP1170
MMETSP1324
MMETSP1326
MMETSP1349
MMETSP1139
MMETSP1140
MMETSP1141
MMETSP1173
MMETSP1327
MMETSP1328
MMETSP1329
MMETSP1355
MMETSP1142
MMETSP1143
MMETSP1144
MMETSP1176
MMETSP1177
MMETSP1330
MMETSP1357
MMETSP1358
MMETSP1147
MMETSP1148
MMETSP1150
MMETSP1180
MMETSP1333
MMETSP1334
MMETSP1335
MMETSP1359
MMETSP1151
MMETSP1152
MMETSP1153
MMETSP1309
MMETSP1310
MMETSP1336
MMETSP1154
MMETSP1155
MMETSP1156
MMETSP1311
MMETSP1312
MMETSP1344
MMETSP1157
MMETSP1315
MMETSP1316
MMETSP1317
MMETSP1346
MMETSP1160
MMETSP1161
MMETSP1082
MMETSP1084
MMETSP1090
MMETSP1091
MMETSP1400
MMETSP1403
MMETSP1404
MMETSP1428
MMETSP1429
MMETSP1085
MMETSP1094
MMETSP1098
MMETSP1101
MMETSP1102
MMETSP1103
MMETSP1104
MMETSP1105
MMETSP1106
MMETSP1107
MMETSP1065
MMETSP1081
MMETSP0580
MMETSP0910
MMETSP0911
MMETSP0912
MMETSP0913
MMETSP0920
MMETSP1110
MMETSP1114
MMETSP0324
MMETSP0492
MMETSP0493
MMETSP0494
MMETSP1374
MMETSP1345
MMETSP1356
MMETSP1360
MMETSP1361
MMETSP1362
MMETSP1363
MMETSP1364
MMETSP1365
MMETSP1366
MMETSP1367
MMETSP1369
MMETSP1370
MMETSP1371
MMETSP1385
MMETSP1386
MMETSP1387
MMETSP1388
MMETSP1389
MMETSP1390
MMETSP1391
MMETSP1392
MMETSP1393
MMETSP1394
MMETSP1395
MMETSP1396
MMETSP1377
MMETSP1380
MMETSP1381
MMETSP1384
MMETSP0790
MMETSP0288
MMETSP0290
MMETSP0308
MMETSP0312
MMETSP0313
MMETSP0314
MMETSP0315
MMETSP1407
MMETSP1408
MMETSP1397
MMETSP1399
MMETSP1401
MMETSP1402
MMETSP1405
MMETSP1406
MMETSP1415
MMETSP1416
MMETSP1423
MMETSP1424
MMETSP1425
MMETSP1417
MMETSP1418
MMETSP1419
MMETSP1420
MMETSP1421
MMETSP1422
MMETSP1409
MMETSP1410
MMETSP1411
MMETSP1412
MMETSP1413
MMETSP1414
MMETSP1426
MMETSP1432
MMETSP0088
MMETSP0090
MMETSP0091
MMETSP0092
MMETSP1012
MMETSP1433
MMETSP1434
MMETSP1435
MMETSP1436
MMETSP1437
MMETSP1438
MMETSP1439
MMETSP1440
MMETSP1441
MMETSP1442
MMETSP1443
MMETSP1444
MMETSP1445
MMETSP1471
MMETSP1475
MMETSP1446
MMETSP1447
MMETSP1449
MMETSP1450
MMETSP1451
MMETSP1452
MMETSP1453
MMETSP1456
MMETSP1460
MMETSP1462
MMETSP1465
MMETSP1467
MMETSP1468