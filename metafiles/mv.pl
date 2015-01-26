#!/usr/bin/env perl
#
use strict;
use warnings;
use feature 'say';
use autodie;
use IMicrobe::DB;
use File::Spec::Functions 'catfile';
use Readonly;

Readonly my $SRC_DIR  => '/iplant/home/shared/imicrobe/camera/camera_projects';
Readonly my $DEST_DIR => '/iplant/home/shared/imicrobe/projects';

main();

# ----------------------------------------------------------------------
sub main {
    my $db     = IMicrobe::DB->new;
    my $Schema = $db->schema;

    my $i;
    for my $file (<DATA>) {
        printf "\n%5d: %s\n", ++$i, $file;
        chomp($file);
        process($file, $Schema);
    }
}

# ----------------------------------------------------------------------
sub process {
    my $file   = shift or return;
    my $Schema = shift;    
    my ($project_code, $type, $ext) = split /\./, $file, 3;

    my %type_to_field = (
        asm      => 'assembly_file',
        csv      => 'meta_file',
        pep      => 'peptide_file',
        read     => 'read_file',
        read_pep => 'read_pep_file',
        nt       => 'nt_file',
    );

    my $fld = $type_to_field{ $type } or die "Bad type ($type)\n";

    my ($Project) = $Schema->resultset('Project')->search({ 
        project_code => $project_code
    });

    if (!$Project) {
        print STDERR "Can't find '$project_code'\n";
        return;
    }

    my $src_file  = catfile($SRC_DIR, $file);
    my $dest_file = catfile($DEST_DIR, $Project->id, $file);

    printf "%s (%s) $file -> $type\n", $project_code, $Project->id;
    say "  $fld -> $dest_file";
    $Project->$fld($dest_file);
    $Project->update;

    say STDERR "icp $src_file $dest_file";
}

__DATA__
CAM_P_00001027.csv
CAM_P_00001027.read.fa
CAM_P_0000504.csv
CAM_P_0000504.read.fa
CAM_P_0000523.csv
CAM_P_0000523.read.fa
CAM_P_0000545.csv
CAM_P_0000545.read.fa
CAM_P_0000692.csv
CAM_P_0000692.read.fa
CAM_P_0000712.csv
CAM_P_0000712.read.fa
CAM_P_0000715.csv
CAM_P_0000715.read.fa
CAM_P_0000719.csv
CAM_P_0000719.read.fa
CAM_P_0000766.csv
CAM_P_0000766.read.fa
CAM_P_0000788.csv
CAM_P_0000788.read.fa
CAM_P_0000791.csv
CAM_P_0000791.read.fa
CAM_P_0000792.csv
CAM_P_0000792.read.fa
CAM_P_0000828.csv
CAM_P_0000828.read.fa
CAM_P_0000851.csv
CAM_P_0000851.read.fa
CAM_P_0000909.csv
CAM_P_0000909.read.fa
CAM_P_0000911.csv
CAM_P_0000911.read.fa
CAM_P_0000912.csv
CAM_P_0000912.read.fa
CAM_P_0000914.csv
CAM_P_0000914.read.fa
CAM_P_0000915.csv
CAM_P_0000915.read.fa
CAM_P_0000917.csv
CAM_P_0000918.csv
CAM_P_0000918.read.fa
CAM_P_0000919.asm.fa
CAM_P_0000919.csv
CAM_P_0000919.read.fa
CAM_P_0000920.csv
CAM_P_0000921.csv
CAM_P_0000921.read.fa
CAM_P_0000948.csv
CAM_P_0000948.read.fa
CAM_P_0000950.csv
CAM_P_0000950.read.fa
CAM_P_0000951.csv
CAM_P_0000951.read.fa
CAM_P_0000957.csv
CAM_P_0000957.read.fa
CAM_P_0001000.csv
CAM_P_0001000.nt.fa
CAM_P_0001000.pep.fa
CAM_P_0001024.csv
CAM_P_0001025.asm.fa
CAM_P_0001025.csv
CAM_P_0001025.read.fa
CAM_P_0001026.csv
CAM_P_0001026.read.fa
CAM_P_0001028.csv
CAM_P_0001028.read.fa
CAM_P_0001048.csv
CAM_P_0001048.read.fa
CAM_P_0001068.csv
CAM_P_0001068.read.fa
CAM_P_0001088.csv
CAM_P_0001088.read.fa
CAM_P_0001089.csv
CAM_P_0001089.nt.fa
CAM_P_0001089.read.tar
CAM_P_0001108.csv
CAM_P_0001108.read.tar
CAM_P_0001109.csv
CAM_P_0001109.read.fa
CAM_P_0001128.csv
CAM_P_0001128.read.fa
CAM_P_0001129.csv
CAM_P_0001129.read.fa
CAM_P_0001130.csv
CAM_P_0001130.read.fa
CAM_P_0001131.csv
CAM_P_0001131.read.fa
CAM_P_0001132.csv
CAM_P_0001132.read.fa
CAM_P_0001133.csv
CAM_P_0001133.read.fa
CAM_P_0001134.csv
CAM_P_0001134.read.tar
CAM_P_0001135.csv
CAM_P_0001135.read.fa
CAM_P_0001136.asm.fa
CAM_P_0001136.csv
CAM_P_0001136.read.tar
CAM_P_0001174.csv
CAM_P_0001174.read.fa
CAM_PROJ_AcidMine.asm.fa
CAM_PROJ_AcidMine.csv
CAM_PROJ_AcidMine.read.fa
CAM_PROJ_AcidMine.read_pep.fa
CAM_PROJ_AlvinellaPompejana.csv
CAM_PROJ_AlvinellaPompejana.read.fa
CAM_PROJ_AlvinellaPompejana.read_pep.fa
CAM_PROJ_AmazonRiverPlume.csv
CAM_PROJ_AmazonRiverPlume.read.fa
CAM_PROJ_AntarcticaAquatic.csv
CAM_PROJ_AntarcticaAquatic.read.fa
CAM_PROJ_AtriplexMicrobiome.csv
CAM_PROJ_AtriplexMicrobiome.read.fa
CAM_PROJ_Bacterioplankton.csv
CAM_PROJ_Bacterioplankton.read.fa
CAM_PROJ_Bacterioplankton.read_pep.fa
CAM_PROJ_BATS.csv
CAM_PROJ_BATS.read.fa
CAM_PROJ_BATS.read_pep.fa
CAM_PROJ_Bbre_splicing.csv
CAM_PROJ_Bbre_splicing.read.fa
CAM_PROJ_BisonMetagenome.csv
CAM_PROJ_BisonMetagenome.read.fa
CAM_PROJ_BotanyBay.csv
CAM_PROJ_BotanyBay.read.fa
CAM_PROJ_BroadPhage.csv
CAM_PROJ_BroadPhageGenomes.csv
CAM_PROJ_BroadPhageGenomes.nt.fa
CAM_PROJ_BroadPhageGenomes.pep.fa
CAM_PROJ_BroadPhage.read.fa
CAM_PROJ_BroadPhage.read_pep.fa
CAM_PROJ_CAM_P0000101.csv
CAM_PROJ_CAM_P0000101.read.fa
CAM_PROJ_CAM_P0000101.read_pep.fa
CAM_PROJ_CBVIRIO.csv
CAM_PROJ_CBVIRIO.read.fa
CAM_PROJ_CBVIRIO.read_pep.fa
CAM_PROJ_CCMP1764.csv
CAM_PROJ_CCMP1764.read.fa
CAM_PROJ_CellCapture.csv
CAM_PROJ_CellCapture.read.fa
CAM_PROJ_ChickenCecum.csv
CAM_PROJ_ChickenCecum.read.fa
CAM_PROJ_CoralMetagenome.csv
CAM_PROJ_CoralMetagenome.read.fa
CAM_PROJ_DayNight.csv
CAM_PROJ_DayNight.read.fa
CAM_PROJ_DeepMed.csv
CAM_PROJ_DeepMed.read.fa
CAM_PROJ_DeepMed.read_pep.fa
CAM_PROJ_DICE.csv
CAM_PROJ_DICE.read.fa
CAM_PROJ_DICE.read_pep.fa
CAM_PROJ_EBPRSludge.csv
CAM_PROJ_EBPRSludge.read.fa
CAM_PROJ_EBPRSludge.read_pep.fa
CAM_PROJ_EpibiontMetagenome.csv
CAM_PROJ_EpibiontMetagenome.read.fa
CAM_PROJ_FarmSoil.asm.fa
CAM_PROJ_FarmSoil.csv
CAM_PROJ_FarmSoil.read.fa
CAM_PROJ_FarmSoil.read_pep.fa
CAM_PROJ_FossilMetagenome.csv
CAM_PROJ_FossilMetagenome.read.fa
CAM_PROJ_GeneExpression.csv
CAM_PROJ_GeneExpression.read.fa
CAM_PROJ_GeneExpression.read_pep.fa
CAM_PROJ_GOS.asm.fa
CAM_PROJ_GOS.csv
CAM_PROJ_GOS.read.fa
CAM_PROJ_GOS.read_pep.fa
CAM_PROJ_GutlessWorm.asm.fa
CAM_PROJ_GutlessWorm.csv
CAM_PROJ_GutlessWorm.read.fa
CAM_PROJ_GutlessWorm.read_pep.fa
CAM_PROJ_HFVirus.csv
CAM_PROJ_HFVirus.read.fa
CAM_PROJ_HMP.csv
CAM_PROJ_HMP.read.fa
CAM_PROJ_HOT.csv
CAM_PROJ_HOT.read.fa
CAM_PROJ_HOT.read_pep.fa
CAM_PROJ_HumanDistalGut.csv
CAM_PROJ_HumanDistalGut.read.fa
CAM_PROJ_HumanGut.asm.fa
CAM_PROJ_HumanGut.csv
CAM_PROJ_HumanGutDiagnosis.csv
CAM_PROJ_HumanGutDiagnosis.read.fa
CAM_PROJ_HydrothermalVent.csv
CAM_PROJ_HydrothermalVent.read.fa
CAM_PROJ_HypersalineMat.csv
CAM_PROJ_HypersalineMat.read.fa
CAM_PROJ_IceMetagenome.csv
CAM_PROJ_IceMetagenome.read.fa
CAM_PROJ_ICOMM.csv
CAM_PROJ_ICOMM.read.fa
CAM_PROJ_IntraDiversity.csv
CAM_PROJ_LakeLimnopolarVirome.csv
CAM_PROJ_LakeLimnopolarVirome.read.fa
CAM_PROJ_LineIsland.csv
CAM_PROJ_LineIsland.read.fa
CAM_PROJ_MarineBrine.csv
CAM_PROJ_MarineBrine.read.fa
CAM_PROJ_MarineBrine.read_pep.fa
CAM_PROJ_MarineMicrobes.csv
CAM_PROJ_MarineMicrobes.nt.fa
CAM_PROJ_MarineMicrobes.pep.fa
CAM_PROJ_MarinePennateDiatoms.csv
CAM_PROJ_MarinePennateDiatoms.read.fa
CAM_PROJ_MarineVirome.asm.fa
CAM_PROJ_MarineVirome.csv
CAM_PROJ_MarineVirome.read.fa
CAM_PROJ_MarineVirome.read_pep.fa
CAM_PROJ_MicrobialCourse.csv
CAM_PROJ_MicrobialCourse.read.fa
CAM_PROJ_Microbialites.csv
CAM_PROJ_Microbialites.read.fa
CAM_PROJ_MontereyBay.csv
CAM_PROJ_MontereyBay.read.fa
CAM_PROJ_MontereyBay.read_pep.fa
CAM_PROJ_MouseGut.asm.fa
CAM_PROJ_MouseGut.csv
CAM_PROJ_MouseSkin.csv
CAM_PROJ_MouseSkin.read.fa
CAM_PROJ_PacificOcean.csv
CAM_PROJ_PacificOcean.read.fa
CAM_PROJ_PBSM.csv
CAM_PROJ_PBSM.read.fa
CAM_PROJ_PeruMarginSediment.csv
CAM_PROJ_PeruMarginSediment.read.fa
CAM_PROJ_PML.csv
CAM_PROJ_PML.read.fa
CAM_PROJ_PML.read_pep.fa
CAM_PROJ_ReclaimedWaterVirues.csv
CAM_PROJ_ReclaimedWaterVirues.read.fa
CAM_PROJ_SalternMetagenome.csv
CAM_PROJ_SalternMetagenome.read.fa
CAM_PROJ_SAM.csv
CAM_PROJ_SAM.read.fa
CAM_PROJ_Sapelo2008.csv
CAM_PROJ_Sapelo2008.read.fa
CAM_PROJ_SapeloIsland.csv
CAM_PROJ_SapeloIsland.read.fa
CAM_PROJ_SapeloIsland.read_pep.fa
CAM_PROJ_SAR11clades.csv
CAM_PROJ_SAR11clades.read.fa
CAM_PROJ_SargassoSea.csv
CAM_PROJ_SargassoSea.read.fa
CAM_PROJ_SargassoSea.read_pep.fa
CAM_PROJ_Synechococcus.csv
CAM_PROJ_Synechococcus.read.fa
CAM_PROJ_Synechococcus.read_pep.fa
CAM_PROJ_SynechococcusWH7803.csv
CAM_PROJ_SynechococcusWH7803.read.fa
CAM_PROJ_TampaBayPhage.csv
CAM_PROJ_TampaBayPhage.read.fa
CAM_PROJ_TermiteGut.asm.fa
CAM_PROJ_TermiteGut.csv
CAM_PROJ_TwinStudy.csv
CAM_PROJ_TwinStudy.read.fa
CAM_PROJ_ViralSpring.csv
CAM_PROJ_ViralSpring.read.fa
CAM_PROJ_ViralSpring.read_pep.fa
CAM_PROJ_ViralStromatolite.csv
CAM_PROJ_ViralStromatolite.read.fa
CAM_PROJ_WashingtonLake.asm.fa
CAM_PROJ_WashingtonLake.csv
CAM_PROJ_Wastewater.csv
CAM_PROJ_WasteWaterMilwaukee.csv
CAM_PROJ_WasteWaterMilwaukee.read.fa
CAM_PROJ_Wastewater.read.fa
CAM_PROJ_WesternChannelOMM.csv
CAM_PROJ_WesternChannelOMM.read.fa
CAM_PROJ_WhaleFall.asm.fa
CAM_PROJ_WhaleFall.csv
CAM_PROJ_WhaleFall.read.fa
CAM_PROJ_WhaleFall.read_pep.fa
CAM_PROJ_Yellowstone.csv
CAM_PROJ_Yellowstone.read.fa
CAM_PROJ_YLake.csv
CAM_PROJ_YLake.read.fa
