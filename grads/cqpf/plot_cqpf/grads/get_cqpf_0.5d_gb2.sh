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
#export hourlist="006 012 018 024 030 036 042 048 054 060 066 072 078 084 090 096 \
#              102 108 114 120 126 132 138 144 150 156 162 168 174 180 186 192\
#              198 204 210 216 222 228 234 240"

#####################
## fetch today's forecast   
#####################
cd $tmpdir   
for nfhrs in $hourlist; do

 if [ $nfhrs -eq 000 -o $nfhrs -eq 006 -o $nfhrs -eq 012 ]; then
  case $nfhrs in
  000) grptime=000_000;nvhrs=00;;
  006) grptime=000_006;nvhrs=06;;
  012) grptime=006_012;nvhrs=12;; 
  esac
#  echo grptime=$grptime
  else
    nshrs=`expr $nfhrs - 6`
    nvhrs=`expr $nshrs + 6`
    if [ $nfhrs -lt 100 ]; then nshrs=0`expr $nfhrs - 6`;fi
    grptime=$nshrs"_"$nfhrs
  fi

cd $tmpdir/opr 
    file1=geprcp.t${cyc}z.pgrb2a.0p50.f${nfhrs} 
    infile1=$datdir1/gefs.$YMD/${cyc}/pgrb2ap5/$file1
    outfile1_tmp=${RUNID}_${CDATE}_${grptime}_tmp
    outfile1=${RUNID}_${CDATE}_${grptime}

  if [ -f $infile1 ]; then
#      wgrib  -s $infile1 | grep $nens | wgrib  $infile1 -s -grib -i -o $outfile1
      $WGRIB2 -match $nens $infile1 -append -grib $outfile1_tmp
  else
      echo " No either $infile1"
      echo " Missing precipitation forecast data detected, quit "
      # export err=8; err_chk
  fi     
     $CNVGRIB -g21 $outfile1_tmp $outfile1
     $SHOME/xbin/grib2ctl -verf $outfile1   > opr_$nvhrs.ctl
     $SHOME/xbin/gribmap -i  opr_$nvhrs.ctl

cd  $tmpdir/cal
    file2=geprcp.t${cyc}z.pgrb2a.0p50.bc_06hf${nfhrs}
    infile2=$datdir2/gefs.$YMD/${cyc}/prcp_bc_gb2/$file2
    outfile2_tmp=$RUNID_${CDATE}_${grptime}_tmp
    outfile2=$RUNID_${CDATE}_${grptime}

  if [ -f $infile2 ]; then
#      wgrib  -s $infile2 | grep $nens | wgrib  $infile2 -s -grib -i -o $outfile2
      $WGRIB2 -match $nens $infile2 -append -grib $outfile2_tmp
  else
      echo " No either $infile2"
      echo " Missing precipitation forecast data detected, quit "
      # export err=8; err_chk
  fi     
     $CNVGRIB -g21 $outfile2_tmp $outfile2
     $SHOME/xbin/grib2ctl -verf  $outfile2  > cal_$nvhrs.ctl
     $SHOME/xbin/gribmap -i  cal_$nvhrs.ctl
done

