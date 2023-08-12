#set -x

CDATE=$1
YMD=`echo $CDATE | cut -c1-8`
cyc=00
#datdir3=/lfs/h1/ops/prod/com/naefs/v6.1

export hourlist=" 036 060 084 108 132 156 180 204 228 252 276 300 324 348 372 "

#####################
## fetch today's forecast   
#####################
cd $tmpdir   
for nfhrs in $hourlist; do
    nshrs=`expr $nfhrs - 24`
    ndhrs=`expr $nfhrs - 0`
    grptime=$nshrs"_"$ndhrs
    file3=gepqpf.t${cyc}z.ndgd2p5_conus.24hf${nfhrs}.gb2
    infile3=$datdir3/gefs.$YMD/${cyc}/ndgd_prcp_gb2/$file3

    $WGRIB2 -match "(^2)"     $infile3 -append -grib pqpf_1.00_dsc_gb2
    $WGRIB2 -match "prob >6.35"  $infile3 -append -grib pqpf_6.35_dsc_gb2
    $WGRIB2 -match "prob >12.7"  $infile3 -append -grib pqpf_12.7_dsc_gb2
    $WGRIB2 -match "prob >25.4"  $infile3 -append -grib pqpf_25.4_dsc_gb2
    $WGRIB2 -match "prob >50.8"  $infile3 -append -grib pqpf_50.8_dsc_gb2

done

    $CNVGRIB -g21  pqpf_1.00_dsc_gb2   pqpf_1.00_dsc
    $CNVGRIB -g21  pqpf_6.35_dsc_gb2   pqpf_6.35_dsc
    $CNVGRIB -g21  pqpf_12.7_dsc_gb2   pqpf_12.7_dsc
    $CNVGRIB -g21  pqpf_25.4_dsc_gb2   pqpf_25.4_dsc
    $CNVGRIB -g21  pqpf_50.8_dsc_gb2   pqpf_50.8_dsc

