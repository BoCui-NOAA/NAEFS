#set -x

CDATE=$1
YMD=`echo $CDATE | cut -c1-8`
cyc=00

#datdir3=/lfs/h1/ops/prod/com/naefs/v6.1

#export hourlist="006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
#              102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192\
#              198 204 210 216 222 228 234 240"

#####################
## fetch today's forecast   
#####################
cd $tmpdir   
for nfhrs in $hourlist; do
    nshrs=`expr $nfhrs - 6`
    ndhrs=`expr $nfhrs - 0`
    grptime=$nshrs"_"$ndhrs
    file3=gepqpf.t${cyc}z.ndgd2p5_conus.06hf${nfhrs}.gb2
    infile3=$datdir3/gefs.$YMD/${cyc}/ndgd_prcp_gb2/$file3

    $WGRIB2 -match "prob >0.254" $infile3 -append -grib pqpf_0.254_dsc_gb2
    $WGRIB2 -match "(^2)"        $infile3 -append -grib pqpf_1.00_dsc_gb2
    $WGRIB2 -match "prob >2.54"  $infile3 -append -grib pqpf_2.54_dsc_gb2
    $WGRIB2 -match "prob >6.35"  $infile3 -append -grib pqpf_6.35_dsc_gb2
    $WGRIB2 -match "prob >12.7"  $infile3 -append -grib pqpf_12.7_dsc_gb2

done

    $CNVGRIB -g21  pqpf_0.254_dsc_gb2  pqpf_0.254_dsc
    $CNVGRIB -g21  pqpf_1.00_dsc_gb2   pqpf_1.00_dsc
    $CNVGRIB -g21  pqpf_2.54_dsc_gb2   pqpf_2.54_dsc
    $CNVGRIB -g21  pqpf_6.35_dsc_gb2   pqpf_6.35_dsc
    $CNVGRIB -g21  pqpf_12.7_dsc_gb2   pqpf_12.7_dsc

