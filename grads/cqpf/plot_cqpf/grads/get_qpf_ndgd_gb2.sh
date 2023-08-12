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

cd $tmpdir/dsc 
    file3=geprcp.t${cyc}z.ndgd2p5_conus.06hf${nfhrs}.gb2
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
     $SHOME/xbin/grib2ctl -verf $outfile3   > dsc_$nvhrs.ctl
     $SHOME/xbin/gribmap -i  dsc_$nvhrs.ctl

done

