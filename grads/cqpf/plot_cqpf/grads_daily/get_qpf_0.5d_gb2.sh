#set -x

CDATE=$1
RUNID=$2
 case $RUNID in
 gfs) nens=hi-res;;
 ctl) nens=low-res;;
 esac

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

cd $tmpdir/opr 
    file1=geprcp.t${cyc}z.pgrb2a.0p50.24hf${nfhrs}
    infile1=$datdir1/gefs.$YMD/${cyc}/pgrb2ap5/$file1
    outfile1_tmp=${RUNID}_${CDATE}_${grptime}_tmp
    outfile1=${RUNID}_${CDATE}_${grptime}

  if [ -f $infile1 ]; then
      $WGRIB2 -match $nens $infile1 -append -grib $outfile1_tmp
  else
      echo " No either $infile1"
      echo " Missing precipitation forecast data detected, quit "
      # export err=8; err_chk
  fi     
     $CNVGRIB -g21 $outfile1_tmp $outfile1
     $SHOME/xbin/grib2ctl -verf $outfile1   > opr_$ndhrs.ctl
     $SHOME/xbin/gribmap -i  opr_$ndhrs.ctl

cd  $tmpdir/cal
    file2=geprcp.t${cyc}z.pgrb2a.0p50.bc_24hf${nfhrs}
    infile2=$datdir2/gefs.$YMD/${cyc}/prcp_bc_gb2/$file2
    outfile2_tmp=$RUNID_${CDATE}_${grptime}_tmp
    outfile2=${RUNID}_${CDATE}_${grptime}

  if [ -f $infile2 ]; then
      $WGRIB2 -match $nens $infile2 -append -grib $outfile2_tmp
  else
      echo " No either $infile2"
      echo " Missing precipitation forecast data detected, quit "
      # export err=8; err_chk
  fi     
     $CNVGRIB -g21 $outfile2_tmp $outfile2
     $SHOME/xbin/grib2ctl -verf  $outfile2  > cal_$ndhrs.ctl
     $SHOME/xbin/gribmap -i  cal_$ndhrs.ctl
done

