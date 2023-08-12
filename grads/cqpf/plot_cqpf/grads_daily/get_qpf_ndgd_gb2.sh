#set -x

CDATE=$1
RUNID=$2
 case $RUNID in
 gfs) nens=hi-res;;
 ctl) nens=low-res;;
 esac

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

cd $tmpdir/dsc 
    file3=geprcp.t${cyc}z.ndgd2p5_conus.24hf${nfhrs}.gb2
    infile3=$datdir3/gefs.$YMD/${cyc}/ndgd_prcp_gb2/$file3
    outfile3_tmp=${RUNID}_${CDATE}_${grptime}_tmp
    outfile3=${RUNID}_${CDATE}_${grptime}

  if [ -f $infile3 ]; then
      $WGRIB2 -match $nens $infile3 -append -grib $outfile3_tmp
  else
      echo " No either $infile1"
      echo " Missing precipitation forecast data detected, quit "
      # export err=8; err_chk
  fi     
     $CNVGRIB -g21  $outfile3_tmp $outfile3
     $SHOME/xbin/grib2ctl -verf $outfile3   > dsc_$ndhrs.ctl
     $SHOME/xbin/gribmap -i  dsc_$ndhrs.ctl

done

