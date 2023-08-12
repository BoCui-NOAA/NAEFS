#set -x

CDATE=$1
YMD=`echo $CDATE | cut -c1-8`
cyc=00
#datdir1=/lfs/h2/emc/vpppg/noscrub/$LOGNAME/ncep_gefs_0.5d
#datdir2=/lfs/h1/ops/prod/com/naefs/v6.1
#export hourlist="006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
#              102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192\
#              198 204 210 216 222 228 234 240"

#####################
## fetch today's forecast   
#####################
cd $tmpdir   
for nfhrs in $hourlist; do
    file1=gepqpf.t${cyc}z.pgrb2a.0p50.f${nfhrs}  
    file2=gepqpf.t${cyc}z.pgrb2a.0p50.bc_06hf${nfhrs} 
    infile1=$datdir1/gefs.$YMD/${cyc}/pgrb2ap5/$file1
    infile2=$datdir2/gefs.$YMD/${cyc}/prcp_bc_gb2/$file2

    $WGRIB2 -match "prob >0.254" $infile1 -append -grib pqpf_0.254_opr_gb2
    $WGRIB2 -match "(^2)"        $infile1 -append -grib pqpf_1.00_opr_gb2
    $WGRIB2 -match "prob >2.54"  $infile1 -append -grib pqpf_2.54_opr_gb2
    $WGRIB2 -match "prob >6.35"  $infile1 -append -grib pqpf_6.35_opr_gb2
    $WGRIB2 -match "prob >12.7"  $infile1 -append -grib pqpf_12.7_opr_gb2

    $WGRIB2 -match "prob >0.254" $infile2 -append -grib pqpf_0.254_cal_gb2
    $WGRIB2 -match "(^2)"        $infile2 -append -grib pqpf_1.00_cal_gb2
    $WGRIB2 -match "prob >2.54"  $infile2 -append -grib pqpf_2.54_cal_gb2
    $WGRIB2 -match "prob >6.35"  $infile2 -append -grib pqpf_6.35_cal_gb2
    $WGRIB2 -match "prob >12.7"  $infile2 -append -grib pqpf_12.7_cal_gb2

done

    $CNVGRIB -g21  pqpf_0.254_opr_gb2  pqpf_0.254_opr
    $CNVGRIB -g21  pqpf_1.00_opr_gb2   pqpf_1.00_opr
    $CNVGRIB -g21  pqpf_2.54_opr_gb2   pqpf_2.54_opr
    $CNVGRIB -g21  pqpf_6.35_opr_gb2   pqpf_6.35_opr
    $CNVGRIB -g21  pqpf_12.7_opr_gb2   pqpf_12.7_opr

    $CNVGRIB -g21  pqpf_0.254_cal_gb2  pqpf_0.254_cal
    $CNVGRIB -g21  pqpf_1.00_cal_gb2   pqpf_1.00_cal
    $CNVGRIB -g21  pqpf_2.54_cal_gb2   pqpf_2.54_cal
    $CNVGRIB -g21  pqpf_6.35_cal_gb2   pqpf_6.35_cal
    $CNVGRIB -g21  pqpf_12.7_cal_gb2   pqpf_12.7_cal

ls pqpf_*
ls pqpf_*opr

