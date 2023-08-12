#set -x

CDATE=$1
YMD=`echo $CDATE | cut -c1-8`
cyc=00
#datdir1=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/ncep_gefs_0.5d
#datdir2=/lfs/h1/ops/prod/com/naefs/v6.1

export hourlist=" 036 060 084 108 132 156 180 204 228 252 276 300 324 348 372 "

#####################
## fetch today's forecast   
#####################
cd $tmpdir   
for nfhrs in $hourlist; do
    nshrs=`expr $nfhrs - 24`
    ndhrs=`expr $nfhrs - 0`
    grptime=$nshrs"_"$ndhrs
    file1=gepqpf.t${cyc}z.pgrb2a.0p50.24hf${nfhrs}
    file2=gepqpf.t${cyc}z.pgrb2a.0p50.bc_24hf${nfhrs}
    infile1=$datdir1/gefs.$YMD/${cyc}/pgrb2ap5/$file1
    infile2=$datdir2/gefs.$YMD/${cyc}/prcp_bc_gb2/$file2

    $WGRIB2 -match "(^2)"     $infile1 -append -grib pqpf_1.00_opr_gb2
    $WGRIB2 -match "prob >6.35"  $infile1 -append -grib pqpf_6.35_opr_gb2
    $WGRIB2 -match "prob >12.7"  $infile1 -append -grib pqpf_12.7_opr_gb2
    $WGRIB2 -match "prob >25.4"  $infile1 -append -grib pqpf_25.4_opr_gb2
    $WGRIB2 -match "prob >50.8"  $infile1 -append -grib pqpf_50.8_opr_gb2

    $WGRIB2 -match "(^2)"     $infile2 -append -grib pqpf_1.00_cal_gb2
    $WGRIB2 -match "prob >6.35"  $infile2 -append -grib pqpf_6.35_cal_gb2
    $WGRIB2 -match "prob >12.7"  $infile2 -append -grib pqpf_12.7_cal_gb2
    $WGRIB2 -match "prob >25.4"  $infile2 -append -grib pqpf_25.4_cal_gb2
    $WGRIB2 -match "prob >50.8"  $infile2 -append -grib pqpf_50.8_cal_gb2

done

    $CNVGRIB -g21  pqpf_1.00_opr_gb2   pqpf_1.00_opr
    $CNVGRIB -g21  pqpf_6.35_opr_gb2   pqpf_6.35_opr
    $CNVGRIB -g21  pqpf_12.7_opr_gb2   pqpf_12.7_opr
    $CNVGRIB -g21  pqpf_25.4_opr_gb2   pqpf_25.4_opr
    $CNVGRIB -g21  pqpf_50.8_opr_gb2   pqpf_50.8_opr

    $CNVGRIB -g21  pqpf_1.00_cal_gb2   pqpf_1.00_cal
    $CNVGRIB -g21  pqpf_6.35_cal_gb2   pqpf_6.35_cal
    $CNVGRIB -g21  pqpf_12.7_cal_gb2   pqpf_12.7_cal
    $CNVGRIB -g21  pqpf_25.4_cal_gb2   pqpf_25.4_cal
    $CNVGRIB -g21  pqpf_50.8_cal_gb2   pqpf_50.8_cal
